<%@ page contentType="text/html;charset=UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
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
<link rel="stylesheet" type="text/css" href="<%=contextPath %>/css/cn/jquery_ui/jquery.ui.all.css"/>
<script type="text/javascript" src="<%=contextPath %>/js/extjs/adapter/ext/ext-base.js"></script> 
<link rel="stylesheet" type="text/css" href="<%=contextPath%>/js/extjs/resources/css/ext-all.css"/>
<script type="text/javascript" src="<%=contextPath %>/js/extjs/ext-all.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/devDialogOpen.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open1.js"></script>
<title>转资列表</title>
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
								<th data-options="field:'zz_id',checkbox:true,align:'center'" width="10">主键</th>
								<th data-options="field:'zz_no',align:'center',sortable:'true'" width="20">转资单号</th>
								<th data-options="field:'zz_num',align:'center',sortable:'true'" width="15">转资台数</th>							
								<th data-options="field:'zz_money',align:'center',sortable:'true'" width="25">转资总金额(元)</th>
								<th data-options="field:'batch_plan',align:'center',sortable:'true'" width="25">批次计划</th>
								<!-- <th data-options="field:'zz_org_name',align:'center',sortable:'true'" formatter='orgNameFormater' width="30">转资机构</th> -->
								<th data-options="field:'lifnr_name',align:'center',sortable:'true'" width="60">供应商名称</th>
								<th data-options="field:'cg_order_num',align:'center',sortable:'true'" width="20">采购单号</th>
								<th data-options="field:'creator',align:'center',sortable:'true'" width="20">创建人</th>
								<th data-options="field:'zz_date',align:'center',sortable:'true'" width="20">转资日期</th>
								<th data-options="field:'zz_state_desc',align:'center',sortable:'true'" width="20">状态</th>
							</tr>
						</thead>
					</table>
					<div id="tb2" style="height:28px;">
						<div style="float:left;height:28px;">						
							&nbsp;&nbsp;转资单号：<input id="zzno" class="input_width query" style="width:90px;float:none;">
							<!-- &nbsp;&nbsp;转资机构：<input id="zzorgname" class="input_width query" style="width:90px;float:none;"> -->
							&nbsp;&nbsp;采购单号：<input id="cgordernum" class="input_width query" style="width:90px;float:none;">
							&nbsp;&nbsp;供应商名称：<input id="lifnrname" class="input_width query" style="width:90px;float:none;">
							&nbsp;&nbsp;转资状态：
							<select id="zzstate" name="zzstate" class="select_width easyui-combobox" data-options="required:true,editable:false,panelHeight:'auto'" style="width:120px;" >
					    	    <option value="" selected="selected">--请选择--</option>
								<option value="1">创建</option>
								<option value="2">已申请</option>
								<option value="3">未转资</option>
								<option value="4">已转资</option>
					    	</select>
						</div>
						<div style="float:left;height:28px;">
							&nbsp;&nbsp;&nbsp;
							<a href="####" class="easyui-linkbutton" onclick="searchDevData()"><i class="fa fa-search fa-lg"></i> 查询</a>
							<a href="####" class="easyui-linkbutton" onclick="advanceSearchWindow()" ><i class="fa fa-filter fa-lg"></i> 高级查询</a>
							<a href="####" class="easyui-linkbutton" onclick="clearQueryText()"><i class="fa fa-minus-square fa-lg"></i> 清除</a>
						</div>
						<div style="float: right;margin-right: 40px;">
						<auth:ListButton functionId="" css="zj" event="onclick='toAdd()'" title="新增"></auth:ListButton>
				    	<auth:ListButton functionId="" css="xg" style="margin:2px 26px;" event="onclick='toEdit()'" title="修改"></auth:ListButton>
				    	<auth:ListButton functionId="" css="sc" event="onclick='toDelete()'" title="删除"></auth:ListButton>
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
						 <td class="inquire_item">转资单号：</td>
					     <td class="inquire_form" colspan="3">
					    	<input type="text" id="zz_no" class="input_width only_read basedet" />
					     </td>
					     <td class="inquire_item">转资台数：</td>
					     <td class="inquire_form" colspan="3">
					    	<input type="text" id="zz_num" class="input_width only_read basedet" />
					     </td>
					     <td class="inquire_item">转资总金额：</td>
					     <td class="inquire_form" colspan="3">
					    	<input type="text" id="zz_money" class="input_width only_read basedet" />
					     </td>
					 </tr>
					 <tr>
						 <td class="inquire_item">批次计划：</td>
					     <td class="inquire_form" colspan="3">
					    	<input type="text" id="batch_plan" class="input_width only_read basedet" />
					     </td>
					     <td class="inquire_item">创建人：</td>
					     <td class="inquire_form" colspan="3">
					    	<input type="text" id="creator" class="input_width only_read basedet" />
					     </td>
					     <td class="inquire_item">供应商名称：</td>
					     <td class="inquire_form" colspan="3">
					    	<input type="text" id="lifnr_name" class="input_width only_read basedet" />
					     </td>
					     <!-- <td class="inquire_item">转资机构：</td>
					     <td class="inquire_form" colspan="3">
					    	<input type="text" id="zz_org_name" class="input_width only_read basedet" />
					     </td> -->
					 </tr>
					  <tr>
					     <td class="inquire_item">转资日期：</td>
					     <td class="inquire_form" colspan="3">
					    	<input type="text" id="zz_date" class="input_width only_read basedet" />
					     </td>
					     <td class="inquire_item">转资状态：</td>
					     <td class="inquire_form" colspan="3">
					    	<input type="text" id="zz_state_desc" class="input_width only_read basedet" />
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
								<th nowrap="false" data-options="field:'eqktx',align:'center',sortable:'true'" width="25">设备名称</th>
								<th nowrap="false" data-options="field:'typbz',align:'center',sortable:'true'" width="20">规格型号</th>
								<th nowrap="false" data-options="field:'dev_coding',align:'center',sortable:'true'" width="30">ERP设备编号</th>
								<th nowrap="false" data-options="field:'inbdt',align:'center',sortable:'true'" width="25">投产日期</th>
								<th nowrap="false" data-options="field:'answt',align:'center',sortable:'true'" width="25">购置金额(元)</th>
								<th nowrap="false" data-options="field:'own_org_name',align:'center',sortable:'true'" formatter='orgNameFormater' width="50">设备所属单位</th>
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
					loadMainInfo(row.zz_id);
				}else if(selectTabIndex == 1){
					//单据明细信息
					loadDetialList(row.zz_id);
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
				//设置基本信息
				loadMainInfo(data.zz_id);
			}else if(selectTabIndex == 1){
				//明细信息
				loadDetialList(data.zz_id);
			}
		},
		queryParams:{//必需参数
		},
		url:"${pageContext.request.contextPath}/rm/dm/getListDataBySrvAndMethod.srq?JCDP_SRV_NAME=ZzSrv&JCDP_OP_NAME=queryTranAssetList",
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
	//初始化订单明细信息
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
//加载采购订单基本信息
function loadMainInfo(zzid){
	if(zzid==""){
		 $(".basedet").each(function(){
			$("#"+this.id).val("");
		});
		return;
	 }
	 $.ajax({
	        type: "POST",
	        url: '${pageContext.request.contextPath}/rm/dm/ajaxRetMapBySrvAndMethod.srq?JCDP_SRV_NAME=ZzSrv&JCDP_OP_NAME=getAssetMainInfo',
	        data:{"zzid":zzid},
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
//加载采购订单明细
function loadDetialList(zzid){
	$("#asset_grid").datagrid({
		queryParams:{'zzid': zzid},
		url:'${pageContext.request.contextPath}/rm/dm/getListDataBySrvAndMethod.srq?JCDP_SRV_NAME=ZzSrv&JCDP_OP_NAME=queryAssetDevDet',
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
	$("#zzstate").combobox("setValue","");
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
	params["zzstate"] = $("#zzstate").combobox("getValue");
	queryParams = params;
	$("#main_grid").datagrid('reload',queryParams);
}
//高级查询
function advanceSearchWindow(){
	window.top.$.JDialog.open('${pageContext.request.contextPath}/dmsManager/zhuanzi/advanceSearch.jsp',{
        win:window,
        width:840,
        height:480,
        title:"转资-高级查询",
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
//添加厂家
function toAdd(){
	popWindow("<%=contextPath%>/dmsManager/zhuanzi/zhuanziAdd.jsp");
}
// 修改
function toEdit(){     
	var items = $('#main_grid').datagrid('getSelections');
		    if(items.length==0){ 
		    	$.messager.alert("提示","请先选中一条记录!","warning");
	     		return;
		    }
		    var ids = items[0].zz_id;
		    popWindowAuto('<%=contextPath%>/dmsManager/zhuanzi/zhuanziAdd.jsp?flag=update&zz_id='+ids,'840:650','');
		
						
}
// 删除
function toDelete(){
	var baseData;
	var items = $('#main_grid').datagrid('getSelections');
    if(items.length==0){ 
    	$.messager.alert("提示","请先选中一条记录!","warning");
 		return;
    } 
   
	if(confirm('确定要删除吗?')){  
		var ids = items[0].zz_id;
		var retObj = jcdpCallService("EquipmentSelectionApply", "deleteUpdateZzInfo", "zz_id="+ids);	
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
</script>
</html>
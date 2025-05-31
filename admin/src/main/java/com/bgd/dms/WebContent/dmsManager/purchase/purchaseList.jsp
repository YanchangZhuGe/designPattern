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
<title>采购订单查询</title>
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
								<th data-options="field:'cg_apply_id',checkbox:true,align:'center'" width="10">主键</th>
								<th data-options="field:'cg_order_num',align:'center',sortable:'true'" width="22">订单编号</th>
								<th data-options="field:'cg_order_type_name',align:'center',sortable:'true'" width="25">订单类型</th>							
								<th data-options="field:'contract_num',align:'center',sortable:'true'" width="35">合同号</th>
								<th data-options="field:'supplier_num',align:'center',sortable:'true'" width="22">供应商编号</th>
								<th data-options="field:'supplier_name',align:'center',sortable:'true'" width="50">供应商名称</th>
								<th data-options="field:'buy_way_name',align:'center',sortable:'true'" width="30">采购方式</th>
								<th data-options="field:'cg_lb_name',align:'center',sortable:'true'" width="30">采购类别</th>
								<th data-options="field:'emp_name',align:'center',sortable:'true'" width="20">创建人</th>
								<th data-options="field:'create_date',align:'center',sortable:'true'" width="20">创建日期</th>
							</tr>
						</thead>
					</table>
					<div id="tb2" style="height:28px;">
						<div style="float:left;height:28px;">						
							&nbsp;&nbsp;订单编号：<input id="cgordernum" class="input_width query" style="width:80px;float:none;">
							&nbsp;&nbsp;合同号：<input id="contractnum" class="input_width query" style="width:80px;float:none;">
							&nbsp;&nbsp;供应商名称：<input id="suppliername" class="input_width query" style="width:80px;float:none;">
							&nbsp;&nbsp;订单类型：<input id="billtype" class="easyui-combobox" data-options="editable:false,panelHeight:'auto'" style="width:90px;float:none;">
							&nbsp;&nbsp;采购方式：<input id="cgway" class="easyui-combobox" data-options="editable:false,panelHeight:'auto'" style="width:110px;float:none;">
					    	&nbsp;&nbsp;采购类别：<input id="cgtype" class="easyui-combobox" data-options="editable:false,panelHeight:'auto'" style="width:115px;float:none;">
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
                <div title="基本信息" style="padding:10px;">
                	<div id="base_detail" data-options="fit:true" class="easyui-panel" title="" style="padding:10px;">
					<table id="detail" width="600" height="100"  style="overflow:hidden;"  class="tab_line_height">
					<tr>
						 <td class="inquire_item">订单编号：</td>
					     <td class="inquire_form" colspan="3">
					    	<input type="text" id="cg_order_num" class="input_width only_read basedet" />
					     </td>
					     <td class="inquire_item">订单类型：</td>
					     <td class="inquire_form" colspan="3">
					    	<input type="text" id="cg_order_type_name" class="input_width only_read basedet" />
					     </td>
					     <td class="inquire_item">合同号：</td>
					     <td class="inquire_form" colspan="3">
					    	<input type="text" id="contract_num" class="input_width only_read basedet" />
					     </td>
					 </tr>
					 <tr>
						 <td class="inquire_item">供应商编号：</td>
					     <td class="inquire_form" colspan="3">
					    	<input type="text" id="supplier_num" class="input_width only_read basedet" />
					     </td>
					     <td class="inquire_item">供应商名称：</td>
					     <td class="inquire_form" colspan="3">
					    	<input type="text" id="supplier_name" class="input_width only_read basedet" />
					     </td>
					     <td class="inquire_item">采购方式：</td>
					     <td class="inquire_form" colspan="3">
					    	<input type="text" id="buy_way_name" class="input_width only_read basedet" />
					     </td>
					 </tr>
					  <tr>
					     <td class="inquire_item">采购类别：</td>
					     <td class="inquire_form" colspan="3">
					    	<input type="text" id="cg_lb_name" class="input_width only_read basedet" />
					     </td>
					     <td class="inquire_item">创建人：</td>
					     <td class="inquire_form" colspan="3">
					    	<input type="text" id="emp_name" class="input_width only_read basedet" />
					     </td>
					     <td class="inquire_item">创建日期：</td>
					     <td class="inquire_form" colspan="3">
					    	<input type="text" id="create_date" class="input_width only_read basedet" />
					     </td>
					 </tr>
				 </table>
                </div>
                </div>
                <div title="单据明细" >
                	<table id="bill_grid">
						<thead>
							<tr>
								<th nowrap="false" data-options="field:'dms_cg_apply_detail_id',align:'center',hidden:true" width="10">主键</th>
								<!-- <th nowrap="false" data-options="field:'line_num',align:'center',sortable:'true'" width="15">行号</th>
								<th nowrap="false" data-options="field:'line_type_name',align:'center',sortable:'true'" width="20">行类型</th> -->
								<th nowrap="false" data-options="field:'banfn_xq',align:'center',sortable:'true'" width="32">需求计划编号</th>
								<th nowrap="false" data-options="field:'banfn_cg',align:'center',sortable:'true'" width="32">采购计划编号</th>
								<th nowrap="false" data-options="field:'dev_coding',align:'center',sortable:'true'" width="40">设备编码</th>
								<th nowrap="false" data-options="field:'dev_name',align:'center',sortable:'true'" width="40">设备名称</th>
								<th nowrap="false" data-options="field:'material_code',align:'center',sortable:'true'" width="50">物料编号</th>
								<th nowrap="false" data-options="field:'material_desc',align:'center',sortable:'true'" formatter='matDescFormater' width="90">物料说明</th>
								<th nowrap="false" data-options="field:'material_group',align:'center',sortable:'true'" width="25">物料组</th>
								<th nowrap="false" data-options="field:'amount',align:'center',sortable:'true'" width="13">数量</th>
								<th nowrap="false" data-options="field:'meas_unit',align:'center',sortable:'true'" width="20">计量单位</th>
								<th nowrap="false" data-options="field:'unit_price',align:'center',sortable:'true'" width="30">单价(元)</th>
								<th nowrap="false" data-options="field:'currency',align:'center',sortable:'true'" width="13">币种</th>
								<th nowrap="false" data-options="field:'amount_money',align:'center',sortable:'true'" width="30">金额(元)</th>
							</tr>
						</thead>
					</table>
                </div>
                <div title="分配明细" >
                	<table id="dist_grid">
						<thead>
							<tr>
								<th nowrap="false" data-options="field:'fp_id',align:'center',hidden:true" width="10">主键</th>
								<th nowrap="false" data-options="field:'line_num',align:'center',sortable:'true'" width="15">行号</th>
								<th nowrap="false" data-options="field:'dev_coding',align:'center',sortable:'true'" width="30">设备编码</th>
								<th nowrap="false" data-options="field:'dev_name',align:'center',sortable:'true'" width="40">设备名称</th>
								<th nowrap="false" data-options="field:'material_code',align:'center',sortable:'true'" width="50">物资编码</th>
								<th nowrap="false" data-options="field:'material_desc',align:'center',sortable:'true'" formatter='matFormater' width="90">物料说明</th>
								<th nowrap="false" data-options="field:'material_group',align:'center',sortable:'true'" width="25">物料组</th>
								<th nowrap="false" data-options="field:'amount',align:'center',sortable:'true'" width="13">数量</th>
								<th nowrap="false" data-options="field:'meas_unit',align:'center',sortable:'true'" width="20">计量单位</th>
								<th nowrap="false" data-options="field:'unit_price',align:'center',sortable:'true'" width="30">单价(元)</th>
								<th nowrap="false" data-options="field:'currency',align:'center',sortable:'true'" width="13">币种</th>
								<th nowrap="false" data-options="field:'amount_money',align:'center',sortable:'true'" width="30">金额(元)</th>
								<th nowrap="false" data-options="field:'accept_org_name',align:'center',sortable:'true'" formatter='orgNameFormater' width="40">资产落户单位</th>
								<th nowrap="false" data-options="field:'remark',align:'center',sortable:'true'" width="20">备注</th>
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
	//设置样式
	$(".only_read").attr("readonly","true");
	$(".only_read").css("border","0").css("color","blue").css("background-color","transparent");
	$("#detail tr").each(function(index){
		if(index%2==0){
			$(this).addClass("datagrid-row-alt");
		}		
	});
	//订单类型
	$('#billtype').combobox({ 
		url:'<%=contextPath%>/rm/dm/toGetJsonPurch.srq?purchcode=5110000221',
		editable:false, //不可编辑状态
		cache: false,
		valueField:'code',   
		textField:'note',
		value:'请选择...'
     });
	//采购方式
	$('#cgway').combobox({ 
		url:'<%=contextPath%>/rm/dm/toGetJsonPurch.srq?purchcode=5110000216',
		editable:false, //不可编辑状态
		cache: false,
		valueField:'code',   
		textField:'note',
		value:'请选择...'
     });
	//采购类别
	$('#cgtype').combobox({ 
		url:'<%=contextPath%>/rm/dm/toGetJsonPurch.srq?purchcode=5110000220',
		editable:false, //不可编辑状态
		cache: false,
		valueField:'code',   
		textField:'note',
		value:'请选择...'
     });
	//如果有行被选中，则加载选中标签的内容
	$('#tab').tabs({
		onSelect: function(title,index){
			selectTabIndex=index;
			var row = $('#main_grid').datagrid('getSelected');
			if(row){
				if(selectTabIndex==0){
					//设置基本信息
					loadMainInfo(row.cg_apply_id);
				}else if(selectTabIndex == 1){
					//单据明细信息
					loadDetialList(row.cg_apply_id);
				}else if(selectTabIndex==2){
					//分配明细信息
					loadDisList(row.cg_order_num);
				}
			}			
		}
	});
	//初始采购订单列表信息
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
				loadMainInfo(data.cg_apply_id);
			}else if(selectTabIndex == 1){
				//明细信息
				loadDetialList(data.cg_apply_id);
			}else if(selectTabIndex==2){
				//分配明细信息
				loadDisList(data.cg_order_num);
			}
		},
		queryParams:{//必需参数
		},
		url:"${pageContext.request.contextPath}/rm/dm/getListDataBySrvAndMethod.srq?JCDP_SRV_NAME=PurchaseSrv&JCDP_OP_NAME=queryCgApplyList",
		onDblClickRow:function(index,data){
		},
		onLoadSuccess : function(data1) {
        }		
	});
	//初始化订单明细信息
	$("#bill_grid").datagrid({ 
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
	//初始化订单分配明细
	$("#dist_grid").datagrid({ 
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
function loadMainInfo(cgapplyid){
	if(cgapplyid==""){
		 $(".basedet").each(function(){
			$("#"+this.id).val("");
		});
		return;
	 }
	 $.ajax({
	        type: "POST",
	        url: '${pageContext.request.contextPath}/rm/dm/ajaxRetMapBySrvAndMethod.srq?JCDP_SRV_NAME=PurchaseSrv&JCDP_OP_NAME=getCGApplyMainInfo',
	        data:{"cgapplyid":cgapplyid},
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
function loadDetialList(cgapplyid){
	$("#bill_grid").datagrid({
		queryParams:{'cgapplyid': cgapplyid},
		url:'${pageContext.request.contextPath}/rm/dm/getListDataBySrvAndMethod.srq?JCDP_SRV_NAME=PurchaseSrv&JCDP_OP_NAME=queryCGApplyDet',
		onLoadSuccess : function(data) {
            for(var i = 0; i < data.rows.length; i++){
                if(data.rows[i].material_desc!= undefined){
                    var materialdesc = data.rows[i].material_desc;
                }
                tipView('materialDesc-' + i,materialdesc,'top');
            }
        },
	});
}
//加载采购订单分配明细
function loadDisList(cgordernum){
	$("#dist_grid").datagrid({
		queryParams:{'cgordernum': cgordernum},
		url:'${pageContext.request.contextPath}/rm/dm/getListDataBySrvAndMethod.srq?JCDP_SRV_NAME=PurchaseSrv&JCDP_OP_NAME=queryFPApplyDet',
		onLoadSuccess : function(data) {
            for(var i = 0; i < data.rows.length; i++){
                if(data.rows[i].material_desc!= undefined){
                    var materialdesc = data.rows[i].material_desc;
                }
                tipView('matDesc-' + i,materialdesc,'top');
                if(data.rows[i].orgname!= undefined){
                    var orgname = data.rows[i].orgname;
                }
                tipView('orgName-' + i,orgname,'top');
            }
        },
	});
}
//清空查询条件
function clearQueryText(){
	$(".query").val("");
	$("#billtype").combobox("setValue","请选择...");
	$("#cgway").combobox("setValue","请选择...");
	$("#cgtype").combobox("setValue","请选择...");
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
	params["billtype"] = $("#billtype").combobox("getValue");
	params["cgway"] = $("#cgway").combobox("getValue");
	params["cgtype"] = $("#cgtype").combobox("getValue");
	queryParams = params;
	$("#main_grid").datagrid('reload',queryParams);
}
//订单明细物料说明
function matDescFormater(value,row,index){
	if(value != "") {
	    return '<div id="materialDesc-'+index+'" style="width:auto;">'+value+'</div>';
	 }else{
	    return value;
	 }
}
//分配明细物料说明
function matFormater(value,row,index){
	if(value != "") {
	    return '<div id="matDesc-'+index+'" style="width:auto;">'+value+'</div>';
	 }else{
	    return value;
	 }
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
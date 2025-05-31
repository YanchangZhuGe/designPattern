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
<title>采购计划</title>
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
								<th data-options="field:'purc_id',checkbox:true,align:'center'" width="10">主键</th>
								<th data-options="field:'purc_num',align:'center',sortable:'true'" width="22">采购单号</th>
								<th data-options="field:'order_type_name',align:'center',sortable:'true'" width="25">采购类型</th>
								<th data-options="field:'purc_year',align:'center',sortable:'true'" width="25">年度</th>							
								<th data-options="field:'org_name',align:'center',sortable:'true'" width="50">所属单位</th>
								<th data-options="field:'fill_per',align:'center',sortable:'true'" width="25">填报人</th>
								<th data-options="field:'fill_date',align:'center',sortable:'true'" width="25">填报日期</th>
								<th data-options="field:'proc_status',align:'center',sortable:'true'" width="25">单据状态</th>
							</tr>
						</thead>
					</table>
					<div id="tb2" style="height:28px;">
						<div style="float:left;height:28px;">						
							&nbsp;&nbsp;采购单号：<input id="purcnum" class="input_width query" style="width:80px;float:none;">
							&nbsp;&nbsp;采购类型：<input id="ordertype" class="easyui-combobox" data-options="editable:false,panelHeight:'auto'" style="width:110px;float:none;">
							&nbsp;&nbsp;年度：<input id="purcyear" class="easyui-combobox" data-options="editable:false,panelHeight:'auto'" style="width:110px;float:none;">
							&nbsp;&nbsp;所属单位：<input id="orgname" class="input_width query" style="width:90px;float:none;">
							&nbsp;&nbsp;单据状态：<select id="procstatus" name="procstatus" class="select_width easyui-combobox" data-options="required:true,editable:false,panelHeight:'auto'" style="width:120px;" >
					    	    <option value="" selected="selected">请选择...</option>
								<option value="1">创建</option>
								<option value="2">处理中</option>
								<option value="3">已审批</option>
					    	</select>
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
						 <td class="inquire_item">采购单号：</td>
					     <td class="inquire_form" colspan="3">
					    	<input type="text" id="purc_num" class="input_width only_read basedet" />
					     </td>
					     <td class="inquire_item">采购类型：</td>
					     <td class="inquire_form" colspan="3">
					    	<input type="text" id="order_type_name" class="input_width only_read basedet" />
					     </td>
					      <td class="inquire_item">年度：</td>
					     <td class="inquire_form" colspan="3">
					    	<input type="text" id="purc_year" class="input_width only_read basedet" />
					     </td>
					 </tr>
					 <tr>
					 	 <td class="inquire_item">所属单位：</td>
					     <td class="inquire_form" colspan="3">
					    	<input type="text" id="org_name" class="input_width only_read basedet" />
					     </td>
					     <td class="inquire_item">填报人：</td>
					     <td class="inquire_form" colspan="3">
					    	<input type="text" id="fill_per" class="input_width only_read basedet" />
					     </td>
					     <td class="inquire_item">填报日期：</td>
					     <td class="inquire_form" colspan="3">
					    	<input type="text" id="fill_date" class="input_width only_read basedet" />
					     </td>
					 </tr>
					 <tr>
					     <td class="inquire_item">单据状态：</td>
					     <td class="inquire_form" colspan="3">
					    	<input type="text" id="proc_status" class="input_width only_read basedet" />
					     </td>
					 </tr>
				 </table>
                </div>
                </div>
                <div title="单据明细" >
                	<table id="bill_grid">
						<thead>
							<tr>
								<th nowrap="false" data-options="field:'detail_id',align:'center',hidden:true" width="10">主键</th>
								<th nowrap="false" data-options="field:'fromreqid',align:'center',sortable:'true'" width="25">需求计划单号</th>								
								<th nowrap="false" data-options="field:'material_code',align:'center',sortable:'true'" width="20">物料编码</th>
								<th nowrap="false" data-options="field:'material_desc',align:'center',sortable:'true'" formatter='matFormater' width="60">物料描述</th>
								<th nowrap="false" data-options="field:'amount',align:'center',sortable:'true'" width="15">数量</th>
								<th nowrap="false" data-options="field:'unit',align:'center',sortable:'true'" width="18">计量单位</th>
								<th nowrap="false" data-options="field:'price',align:'center',sortable:'true'" width="20">金额(元)</th>
								<th nowrap="false" data-options="field:'apply_dnum',align:'center',sortable:'true'" width="35">申请文号</th>
								<th nowrap="false" data-options="field:'own_org_name',align:'center',sortable:'true'" formatter='orgNameFormater' width="35">所属单位</th>
								<th nowrap="false" data-options="field:'contact',align:'center',sortable:'true'" width="15">联系人</th>
								<th nowrap="false" data-options="field:'phone',align:'center',sortable:'true'" width="28">联系方式</th>
								<th nowrap="false" data-options="field:'remark',align:'center',sortable:'true'" formatter='remarkFormater' width="35">备注</th>
							</tr>
						</thead>
					</table>
                </div>
                <div title="审批明细" >
                	<table id="dist_grid">
						<thead>
							<tr>
								<th nowrap="false" data-options="field:'sync_id',align:'center',hidden:true" width="10">主键</th>
								<th nowrap="false" data-options="field:'busi_node',align:'center',sortable:'true'" width="30">业务环节</th>
								<th nowrap="false" data-options="field:'appr_status',align:'center',sortable:'true'" width="30">审批情况</th>
								<th nowrap="false" data-options="field:'appr_opinion',align:'center',sortable:'true'" formatter='apprFormater' width="80">审批意见</th>
								<th nowrap="false" data-options="field:'appr_per',align:'center',sortable:'true'" width="20">审批人</th>
								<th nowrap="false" data-options="field:'appr_time',align:'center',sortable:'true'" width="30">审批时间</th>
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
	//采购类型
	$('#ordertype').combobox({ 
		url:'<%=contextPath%>/rm/dm/toGetJsonPurch.srq?purchcode=5110000223',
		editable:false, //不可编辑状态
		cache: false,
		valueField:'code',   
		textField:'note',
		value:'请选择...'
     });
	//年度
	$("#purcyear").combobox({ 
		editable:false, //不可编辑状态
		cache: false,
		valueField:'year',    
		textField:'year',  
		panelHeight:'auto',
		value:'请选择...'
	});
	var data = [];//创建年度数组
	var startYear;//起始年份
	var thisYear = new Date().getUTCFullYear();//今年
	var endYear = thisYear+1;//结束年份
	for(startYear = endYear-4;startYear<endYear;startYear++){
        data.push({"year":startYear});
    }
	$("#purcyear").combobox("loadData", data);//下拉框加载数据
	//如果有行被选中，则加载选中标签的内容
	$('#tab').tabs({
		onSelect: function(title,index){
			selectTabIndex=index;
			var row = $('#main_grid').datagrid('getSelected');
			if(row){
				if(selectTabIndex==0){
					//设置基本信息
					loadMainInfo(row.purc_id);
				}else if(selectTabIndex == 1){
					//单据明细信息
					loadDetialList(row.purc_id);
				}else if(selectTabIndex==2){
					//审批明细信息
					loadDisList(row.purc_id);
				}
			}			
		}
	});
	//初始采购计划列表信息
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
				loadMainInfo(data.purc_id);
			}else if(selectTabIndex == 1){
				//明细信息
				loadDetialList(data.purc_id);
			}else if(selectTabIndex==2){
				//分配明细信息
				loadDisList(data.purc_id);
			}
		},
		queryParams:{//必需参数
		},
		url:"${pageContext.request.contextPath}/rm/dm/getListDataBySrvAndMethod.srq?JCDP_SRV_NAME=ExePlanSrv&JCDP_OP_NAME=queryExePurcList",
		onDblClickRow:function(index,data){
		},
		onLoadSuccess : function(data1) {
        }		
	});
	//初始化采购计划明细信息
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
	//初始化审批明细
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
//加载采购计划基本信息
function loadMainInfo(purcid){
	if(purcid==""){
		 $(".basedet").each(function(){
			$("#"+this.id).val("");
		});
		return;
	 }
	 $.ajax({
	        type: "POST",
	        url: '${pageContext.request.contextPath}/rm/dm/ajaxRetMapBySrvAndMethod.srq?JCDP_SRV_NAME=ExePlanSrv&JCDP_OP_NAME=getExePurcMainInfo',
	        data:{"purcid":purcid},
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
//加载采购计划明细
function loadDetialList(purcid){
	$("#bill_grid").datagrid({
		queryParams:{'purcid': purcid},
		url:'${pageContext.request.contextPath}/rm/dm/getListDataBySrvAndMethod.srq?JCDP_SRV_NAME=ExePlanSrv&JCDP_OP_NAME=queryExePurcDet',
		onLoadSuccess : function(data) {
            for(var i = 0; i < data.rows.length; i++){
            	if(data.rows[i].material_desc!= undefined){
                    var materialdesc = data.rows[i].material_desc;
                }
                tipView('matDesc-' + i,materialdesc,'top');
                if(data.rows[i].own_org_name!= undefined){
                    var orgname = data.rows[i].org_name;
                }
                tipView('orgName-' + i,orgname,'top');
                if(data.rows[i].remark!= undefined){
                    var remark = data.rows[i].remark;
                }
                tipView('remark-' + i,remark,'top');
            }
        },
	});
}
//加载审批明细明细
function loadDisList(purcid){
	$("#dist_grid").datagrid({
		queryParams:{'syncid': purcid},
		url:'${pageContext.request.contextPath}/rm/dm/getListDataBySrvAndMethod.srq?JCDP_SRV_NAME=ExePlanSrv&JCDP_OP_NAME=queryExePlanApprovalDet',
		onLoadSuccess : function(data) {
            for(var i = 0; i < data.rows.length; i++){
            	 if(data.rows[i].appr_opinion!= undefined){
                     var appropinion = data.rows[i].appr_opinion;
                 }
                 tipView('appr-' + i,appropinion,'top');
            }
        },
	});
}
//清空查询条件
function clearQueryText(){
	$(".query").val("");
	$("#ordertype").combobox("setValue","请选择...");
	$("#procstatus").combobox("setValue","请选择...");
	$("#purcyear").combobox("setValue","请选择...");
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
	params["ordertype"] = $("#ordertype").combobox("getValue");
	params["procstatus"] = $("#procstatus").combobox("getValue");
	params["purcyear"] = $("#purcyear").combobox("getValue");
	queryParams = params;
	$("#main_grid").datagrid('reload',queryParams);
}
//单据明细物料说明
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
//备注全称
function remarkFormater(value,row,index){
	if(value != "") {
	    return '<div id="remark-'+index+'" style="width:auto;">'+value+'</div>';
	 }else{
	    return value;
	 }
}
//审批意见
function apprFormater(value,row,index){
	if(value != "") {
	    return '<div id="appr-'+index+'" style="width:auto;">'+value+'</div>';
	 }else{
	    return value;
	 }
}
</script>
</html>
<%@ page contentType="text/html;charset=UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="java.util.*,com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="easyuiAuth" uri="easyuiAuth"%>
<%@taglib prefix="auth" uri="auth"%>
<%@ page import="com.cnpc.jcdp.cfg.BeanFactory"%>
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
<title>保养计划</title>
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
								<th data-options="field:'cost_manager_id',checkbox:true,align:'center'" width="10">主键</th>
								<th data-options="field:'dev_name',align:'center',sortable:'true'" width="20">设备名称</th>
								<th data-options="field:'dev_model',align:'center',sortable:'true'" width="20">规格型号</th>
								<th data-options="field:'self_num',align:'center',sortable:'true'" width="20">自编号</th>
								<th data-options="field:'license_num',align:'center',sortable:'true'" width="20">牌照号</th>
								<th data-options="field:'dev_sign',align:'center',sortable:'true'" width="20">实物标识号</th>
								<th data-options="field:'apply_name',align:'center',sortable:'true'"  width="20">申请单名称</th>
								<th data-options="field:'oper',align:'center',sortable:'true'"  width="20">申请人</th>
								<th data-options="field:'stat',align:'center',sortable:'true'"  width="20">申请状态</th>
								<th data-options="field:'total_money',align:'center',sortable:'true'"  width="20">金额(元)</th>
								<th data-options="field:'date1',align:'center',hidden:true" width="20">时间差</th><!-- 隐藏属性 -->
							</tr>
						</thead>
					 </table>
					 <div id="tb2" style="height:28px;">
						<div style="float:left;height:28px;">						
							&nbsp;&nbsp;设备名称：<input id="s_dev_name" class="input_width query" style="width:75px;float:none;">
							&nbsp;&nbsp;规格型号：<input id="s_dev_model" class="input_width query" style="width:75px;float:none;">	
							&nbsp;&nbsp;自编号：<input id="s_self_num" class="input_width query" style="width:75px;float:none;">	
							&nbsp;&nbsp;牌照号：<input id="s_license_num" class="input_width query" style="width:75px;float:none;">	
							&nbsp;&nbsp;实物标识号：<input id="s_dev_sign" class="input_width query" style="width:75px;float:none;">	
						</div>
						<div style="float:left;height:28px;">
							&nbsp;&nbsp;&nbsp;
							<a href="####" class="easyui-linkbutton" onclick="searchDevData()"><i class="fa fa-search fa-lg"></i> 查询</a>
							<a href="####" class="easyui-linkbutton" onclick="clearQueryText()"><i class="fa fa-minus-square fa-lg"></i> 清除</a>
						</div>
						<div style="float:right;height:28px;">
							<a href="####" class="easyui-linkbutton" onclick="toAddPage()"><i class="fa fa-plus-circle fa-lg"></i> 新增</a>
							<a href="####" class="easyui-linkbutton" onclick="toModifyPage()"><i class="fa fa-pencil-square fa-lg"></i> 修改</a>
							<a href="####" class="easyui-linkbutton" onclick="toDelPage()"><i class="fa fa-trash-o fa-lg"></i> 删除</a>	
							<a href="####" class="easyui-linkbutton" onclick="toTJ('3')"><i class="fa fa-check-square-o fa-lg"></i>提交</a>					
							<a href="####" class="easyui-linkbutton" onclick="opSH()"><i class="fa fa-file-text fa-lg"></i>审批</a>					
						</div>						
					</div>
				</div>
			</div>
		</div>
		<!-- 页面下半部分 -->
		<div id="center" data-options="region:'center',title:'',split:true">	
			  <div id="tab" class="easyui-tabs" data-options="fit:true,plain:true">
                <div title="票据明细" style="padding:10px;">
                	<div id="mixcoll_detail" data-options="fit:true" class="easyui-panel" title="" style="padding:10px;">
                	<table id="mixinfo_grid">
						<thead>
							<tr>
								<th nowrap="false" data-options="field:'coding_name',align:'center'" width="40">票据名称</th>
								<th nowrap="false" data-options="field:'costs',align:'center'" width="40">票据金额(元)</th>
								<th nowrap="false" data-options="field:'cost_date',align:'center'" width="40">票据时间</th>
							</tr>
						</thead>
					</table>
                </div>
                </div>         
           	 </div>
		</div>
	</div>
	<div id="win"></div>
	 <div id="dlg" align="center" class="easyui-dialog" title="操作提示" style="width:400px;height:200px;padding:10px"
			data-options="
				iconCls: 'icon-save',
				closed: true,
				buttons: [{
					text:'审批通过',
					iconCls:'icon-ok',
					handler:function(){
						toSH('1');
					}
				},{
					text:'审批不通过',
					iconCls:'icon-no',
					handler:function(){
						toSH('0');
					}
				}]
			">
		 是否审批通过？ 
	</div>
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
	//如果有行被选中，则加载选中标签的内容
	$('#tab').tabs({
		onSelect: function(title,index){
			selectTabIndex=index;
			var row = $('#mixcoll_grid').datagrid('getSelected');
			if(row){
				if(selectTabIndex==0){
					//明细信息
					loadMixCollDetial(row.fk_dev_acc_id);
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
        	loadMixCollDetial(row.cost_manager_id);
    	},
		onClickRow:function(index,data){
			currentId = data.cost_manager_id;
			if(selectTabIndex==0){
				//明细信息
				loadMixCollDetial(currentId);
			}
		},
		rowStyler:function(index,row){
			if (row.plan_date<=0){
				row.plan_date ='<font color="#FF0000">请制定保养计划</font>';
			}
			if (row.date1<=3 && row.date1>0){
				return 'background-color:pink;color:black;';
			}
		},
		url:"${pageContext.request.contextPath}/dmsManager/costmanager/queryCostManagerList.srq?JCDP_SRV_NAME=DevCostManagerSrv&JCDP_OP_NAME=queryCostManagerList"
	});
	//初始化详细信息
	debugger;
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
});
var cost_manager_id1;
//加载详细信息
function loadMixCollDetial(mix_id){
	cost_manager_id1=mix_id;
	$("#mixinfo_grid").datagrid({
		queryParams:{'cost_manager_id': mix_id},
		url:"${pageContext.request.contextPath}/dmsManager/costmanager/queryCostManagerList.srq?JCDP_SRV_NAME=DevCostManagerSrv&JCDP_OP_NAME=queryCostManagerDList",
		/* onClickRow:function(index,data){subgo(data.device_detail_rid);} */
	});
}
//添加
function toAddPage(){
	popWindow('${pageContext.request.contextPath}/dmsManager/costmanager/cost_add.jsp',"950:480","-添加单机成本");
}
//修改
function toModifyPage(){
	var row = $('#mixcoll_grid').datagrid('getSelected');
	if (row){
		if('未提交'!=row.stat&&'审批不通过'!=row.stat){
			$.messager.alert('提示','只能修改未提交单据!','warning');
			return ;
		}
		popWindow('${pageContext.request.contextPath}/dmsManager/costmanager/cost_add.jsp?flag=update&cost_manager_id='+row.cost_manager_id,'950:480','-修改单据');
	}else{
		$.messager.alert('提示','请选择记录!','warning');
	}
}

//删除单据
function toDelPage(){
	var row = $('#mixcoll_grid').datagrid('getSelected');
	if (row){
		 
		if('未提交'!=row.stat){
			$.messager.alert('提示','只能删除未提交单据!','warning');
			return ;
		}
		$.messager.confirm("操作提示", "您确定要执行操作吗？", function (data) {
	        if (data) {
				var retObj = jcdpCallService("DevCostManagerSrv", "delCostManagerById", "cost_manager_id="+row.cost_manager_id);
				queryData(cruConfig.currentPage);
			}
	        searchDevData();
		});
	}else{
		$.messager.alert('提示','请选择记录!','warning');
	}
}
//提交通过
function toTJ(stat){
	var row = $('#mixcoll_grid').datagrid('getSelected');
	if (row){
		if('未提交'!=row.stat){
			$.messager.alert('提示','只能提交未提交单据!','warning');
			return ;
		}
		$.messager.confirm("操作提示", "您确定要执行操作吗？", function (data) {
	        if (data) {
				var retObj = jcdpCallService("DevCostManagerSrv", "tjCostManagerById", "cost_manager_id="+row.cost_manager_id+"&stat="+stat);
				queryData(cruConfig.currentPage);
			}
	        searchDevData();
		});
	}else{
		$.messager.alert('提示','请选择记录!','warning');
	}
}
//审核操作
function toSH(stat){
	$('#dlg').dialog('close');
	var retObj = jcdpCallService("DevCostManagerSrv", "shCostManagerById", "cost_manager_id="+cost_manager_id1+"&stat="+stat);
	queryData(cruConfig.currentPage);
    searchDevData();

}
//审核通过
function opSH(){
	
	var row = $('#mixcoll_grid').datagrid('getSelected');
	if (row){
		if('已提交'!=row.stat){
			$.messager.alert('提示','只能审核已提交单据!','warning');
			return ;
		}
		$('#dlg').dialog('open');
	    	
	}else{
		$.messager.alert('提示','请选择记录!','warning');
	}
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
	//必须条件
	queryParams = params;
	$("#mixcoll_grid").datagrid('reload',queryParams);
}

</script>
</html>
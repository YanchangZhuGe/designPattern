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
<title>燃油消耗</title>
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
								<th data-options="field:'teammat_out_id',checkbox:true,align:'center'" width="10">主键</th>
								<th data-options="field:'wz_name',align:'center',sortable:'true'" width="20">油料名称</th>
								<th data-options="field:'actual_price',align:'center',sortable:'true'" width="20">单价</th>
								<th data-options="field:'oil_num',align:'center',sortable:'true'" width="20">油料数量(升)</th>
								<th data-options="field:'mat_num',align:'center',sortable:'true'" width="20">油料数量(吨)</th>
								<th data-options="field:'total_money',align:'center',sortable:'true'" width="20">金额(元)</th>
								<th data-options="field:'user_name',align:'center',sortable:'true'"  width="20">创建人</th>
								<th data-options="field:'outmat_date',align:'center',sortable:'true'" width="20">消耗时间</th>
								<th data-options="field:'oil_from',align:'center',sortable:'true'" width="20">油料来源</th>
							</tr>
						</thead>
					 </table>
					 <div id="tb2" style="height:28px;">
						<div style="float:left;height:28px;">						
							&nbsp;&nbsp;设备名称：<input id="s_dev_name" class="input_width query" style="width:75px;float:none;">
							&nbsp;&nbsp;自编号：<input id="s_self_num" class="input_width query" style="width:75px;float:none;">	
							&nbsp;&nbsp;牌照号：<input id="s_license_num" class="input_width query" style="width:75px;float:none;">
							&nbsp;&nbsp;创建人：<input id="s_user_name" class="input_width query" style="width:75px;float:none;">	
						</div>
						<div style="float:left;height:28px;">
							&nbsp;&nbsp;&nbsp;
							<a href="####" class="easyui-linkbutton" onclick="searchDevData()"><i class="fa fa-search fa-lg"></i> 查询</a>
							<a href="####" class="easyui-linkbutton" onclick="clearQueryText()"><i class="fa fa-minus-square fa-lg"></i> 清除</a>
						</div>
						<div style="float:right;height:28px;">
							<a href="javascript:downloadModel('主台帐燃油消耗导入模板')" class="easyui-linkbutton"><i class="fa fa-file-excel-o fa-lg"></i>下载模板</a>
							<a href="####" class="easyui-linkbutton" onclick="toAddMixPlanPage()"><i class="fa fa-plus-circle fa-lg"></i> 新增</a>
							<a href="####" class="easyui-linkbutton" onclick="toModifyMixPlanPage()"><i class="fa fa-pencil-square fa-lg"></i> 修改</a>
							<a href="####" class="easyui-linkbutton" onclick="toDelMixPlanPage()"><i class="fa fa-trash-o fa-lg"></i> 删除</a>	
							<a href="####" class="easyui-linkbutton" onclick="AddExcelData()"><i class="fa fa-file-text fa-lg"></i> 导入</a>	
						</div>						
					</div>
				</div>
			</div>
		</div>
		<!-- 页面下半部分 -->
		<div id="center" data-options="region:'center',title:'',split:true">	
			  <div id="tab" class="easyui-tabs" data-options="fit:true,plain:true">
                <div title="保养明细" style="padding:10px;">
                	<div id="mixcoll_detail" data-options="fit:true" class="easyui-panel" title="" style="padding:10px;">
                	<table id="mixinfo_grid">
						<thead>
							<tr>
								<th nowrap="false" data-options="field:'dev_name',align:'center',sortable:'true'" width="15">设备名称</th>
								<th nowrap="false" data-options="field:'self_num',align:'center',sortable:'true'" width="15">自编号</th>
								<th nowrap="false" data-options="field:'license_num',align:'center',sortable:'true'" width="20">牌照号</th>
								<th nowrap="false" data-options="field:'dev_sign',align:'center',sortable:'true'" width="25">实物标识号</th>
								<th nowrap="false" data-options="field:'operator_name',align:'center',sortable:'true'" formatter='comFormater' width="40">操作手</th>
								<th nowrap="false" data-options="field:'wz_prickie',align:'center',sortable:'true'" width="10">计量单位</th>
								<th nowrap="false" data-options="field:'actual_price',align:'center',sortable:'true'" width="10">实际单价</th>
								<th nowrap="false" data-options="field:'oil_num',align:'center',sortable:'true'" width="13">使用数量(升)</th>
								<th nowrap="false" data-options="field:'mat_num',align:'center',sortable:'true'" width="13">使用数量(吨)</th>
								<th nowrap="false" data-options="field:'total_money',align:'center',sortable:'true'" width="10">金额</th>
							</tr>
						</thead>
					</table>
                </div>
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
	//如果有行被选中，则加载选中标签的内容
	$('#tab').tabs({
		onSelect: function(title,index){
			selectTabIndex=index;
			var row = $('#mixcoll_grid').datagrid('getSelected');
			if(row){
				if(selectTabIndex==0){
					//明细信息
					loadMixCollDetial(row.teammat_out_id);
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
        	loadMixCollDetial(row.teammat_out_id);
    	},
		onClickRow:function(index,data){
			currentId = data.teammat_out_id;
			if(selectTabIndex==0){
				//明细信息
				loadMixCollDetial(currentId);
			}
		},
		url:"${pageContext.request.contextPath}/dmsManager/safekeeping/queryMaintainDevList.srq?JCDP_SRV_NAME=DevRepairList&JCDP_OP_NAME=getExpendList"
	});
	//初始化详细信息
	debugger;
	$("#mixinfo_grid").datagrid({ 
		method:'post',
		rownumbers:true,
		title:"",
		toolbar:'',
		border:false,
		striped:true,
		pagination:true,
		fit:true,
		fitColumns:true,
		onLoadSuccess : function(data1) {
            for(var i = 0; i < data1.rows.length; i++){
                if(data1.rows[i].operator_name!= undefined){
                    var operator_name = data1.rows[i].operator_name;
                }
                tipView('comFullName-' + i,operator_name,'top');
            }
        }
	});
});

//加载详细信息
function loadMixCollDetial(id){
	$("#mixinfo_grid").datagrid({
		queryParams:{'id': id},
		url:"${pageContext.request.contextPath}/dmsManager/safekeeping/getMaintainDevInfo.srq?JCDP_SRV_NAME=DevRepairList&JCDP_OP_NAME=getExpendtain",
		/* onClickRow:function(index,data){subgo(data.device_detail_rid);} */
	});
}
//添加
function toAddMixPlanPage(){
	popWindow('${pageContext.request.contextPath}/dmsManager/safekeeping/equipmentOperator/eo_add.jsp','950:480','-添加燃油消耗');
}
//修改
function toModifyMixPlanPage(){
	var row = $('#mixcoll_grid').datagrid('getSelected');
	if (row){
		popWindow('${pageContext.request.contextPath}/rm/dm/devRun/equipmentOperator/toEOEdit.srq?teammatOutId='+row.teammat_out_id,'950:480','-修改燃油消耗');
	}else{
		$.messager.alert('提示','请选择记录!','warning');
	}
}

//删除单据
function toDelMixPlanPage(){
	var row = $('#mixcoll_grid').datagrid('getSelected');
	if (row){
		$.messager.confirm("操作提示", "您确定要执行操作吗？", function (data) {
	        if (data) {
				var retObj = jcdpCallService("MatItemSrv", "deleteConsumption", "ids="+row.teammat_out_id);
				queryData(cruConfig.currentPage);
			}
	        searchDevData();
		});
	}else{
		$.messager.alert('提示','请选择记录!','warning');
	}
}

//导入exc
function AddExcelData(){
	 popWindow("<%=contextPath%>/dmsManager/safekeeping/equipmentOperator/eo_import.jsp");
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

function downloadModel(filename){
	filename = encodeURI(filename);
	filename = encodeURI(filename);
	window.location.href="<%=contextPath%>/mat/singleproject/mattemplate/download.jsp?path=/dmsManager/safekeeping/equipmentOperator/oilInport.xlsx&filename="+filename+".xlsx";
}

//操作手简写名称
function comFormater(value,row,index){
    if(value&&value.length>19) {
       var filedName = value.substring(0,19)+"...";
       return '<div id="comFullName-'+index+'" style="width:auto;">'+filedName+'</div>';
   }else{
       return value;
   }
}

</script>
</html>
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
<title>维修信息列表</title>
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
		<div id="north" data-options="region:'north',split:true" style="height:405px;">
			<div class="easyui-layout" data-options="fit:true">
				<!-- 页面上半部分的内容 -->
				<div data-options="region:'center',border:false,split:false" > 
					<table id="main_grid">
						<thead data-options="frozen:true">
							<tr>
								<th data-options="field:'repair_info',checkbox:true,align:'center'" width="10">主键</th>
								<th data-options="field:'dev_name',align:'center',sortable:'true'" width="100">设备名称</th>
								<th data-options="field:'dev_model',align:'center',sortable:'true'" width="110">规格型号</th>							
								<th data-options="field:'self_num',align:'center',sortable:'true'" width="60">自编号</th>
								<th data-options="field:'license_num',align:'center',sortable:'true'" width="70">牌照号</th>
								<th data-options="field:'dev_sign',align:'center',sortable:'true'" width="80">实物标识号</th>
								<%if(user.getSubOrgIDofAffordOrg().equals("C105")) {%> 
			    					<th data-options="field:'org_abbreviation',align:'center',sortable:'true'" formatter='orgNameFormater' width="110">所属单位</th>
			   					<% } else {%>
			   						<th data-options="field:'abbrevname',align:'center',sortable:'true'" formatter='orgNameFormater' width="110">所属单位</th>
			   					<% } %>
								<th data-options="field:'human_cost',align:'center',sortable:'true'" width="100">工时费</th>
								<th data-options="field:'material_cost',align:'center',sortable:'true'" width="100">材料费</th>
							</tr>
						</thead>
						<thead>
							<tr>
								<th data-options="field:'repairtype',align:'center',sortable:'true'" width="70">维修类型</th>
								<th data-options="field:'repairlevel',align:'center',sortable:'true'" width="70">维修级别</th>
								<th data-options="field:'project_name',align:'center',sortable:'true'" formatter='proNameFormater' width="220">项目描述</th>
								<th data-options="field:'repair_detail',align:'center',sortable:'true'" width="220">维修详情</th>
								<th data-options="field:'repair_start_date',align:'center',sortable:'true'" width="80">送修日期</th>
								<th data-options="field:'repair_end_date',align:'center',sortable:'true'" width="80">验收日期</th>
								<th data-options="field:'repairer',align:'center',sortable:'true'" width="70">承修人</th>
								<th data-options="field:'accepter',align:'center',sortable:'true'" width="70">验收人</th>
								<th data-options="field:'repair_postion',align:'center',sortable:'true'" width="160">维修单位</th>
								<th data-options="field:'data_from_name',align:'center',sortable:'true'" width="70">数据来源</th>
							</tr>
						</thead>
					</table>
					<div id="tb2" style="height:28px;">
						<div style="float:left;height:28px;">						
							&nbsp;&nbsp;设备名称：<input id="devname" class="input_width query" style="width:90px;float:none;">
							&nbsp;&nbsp;规格型号：<input id="devmodel" class="input_width query" style="width:90px;float:none;">
							&nbsp;&nbsp;牌照号：<input id="licensenum" class="input_width query" style="width:90px;float:none;">
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
                <div title="维修基本信息" style="padding:10px;">
					<iframe id="detail" scrolling="yes" frameborder="0" src="" style="width:100%;height:100%;"></iframe>
                </div>
                <div title="消耗备件" >
                	<table id="spare_grid">
						<thead>
							<tr>
								<th nowrap="false" data-options="field:'repair_detail_id',align:'center',hidden:true" width="10">主键</th>
								<th nowrap="false" data-options="field:'repairitemname',align:'center',sortable:'true'" width="25">维修项目</th>
								<th nowrap="false" data-options="field:'material_coding',align:'center',sortable:'true'" width="25">物料编码</th>
								<th nowrap="false" data-options="field:'material_name',align:'center',sortable:'true'" formatter='matFormater' width="65">物料描述</th>
								<th nowrap="false" data-options="field:'name_text',align:'center',sortable:'true'" width="25">发料人</th>
								<th nowrap="false" data-options="field:'material_unit',align:'center',sortable:'true'" width="15">计量单位</th>
								<th nowrap="false" data-options="field:'unit_price',align:'center',sortable:'true'" width="25">单价(元)</th>
								<th nowrap="false" data-options="field:'material_amout',align:'center',sortable:'true'" width="15">消耗数量</th>
								<th nowrap="false" data-options="field:'total_charge',align:'center',sortable:'true'" width="30">总价(元)</th>
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
					loadMainInfo(row.repair_info,row.msflag);
				}else if(selectTabIndex == 1){
					//单据明细信息
					loadDetialList(row.repair_info);
				}
			}			
		}
	});
	//初始化维修信息
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
		fitColumns:false,
		showFooter: true,
		pageList:[10, 50, 100, 200, 300],
		onClickRow:function(index,data){
			if(selectTabIndex==0){
				//设置基本信息
				loadMainInfo(data.repair_info,data.msflag);
			}else if(selectTabIndex == 1){
				//明细信息
				loadDetialList(data.repair_info);
			}
		},
		queryParams:{//必需参数
		},
		url:"${pageContext.request.contextPath}/rm/dm/getListDataBySrvAndMethod.srq?JCDP_SRV_NAME=DevRepairSrv&JCDP_OP_NAME=queryDevRepairList",
		onDblClickRow:function(index,data){//双击以弹出窗口的形式展示维修明细数据
			window.top.$.JDialog.open('${pageContext.request.contextPath}/rm/dm/dev_work/devRepairDetail.jsp?repair_info='+data.repair_info+'&msflag='+data.msflag,
			{
		        win:window,
		        width:900,
		        title:"查看维修信息"
		     } ); 
		},
		onLoadSuccess : function(data1) {
			for(var i = 0; i < data1.rows.length; i++){
                if(data1.rows[i].org_name!= undefined){
                    var orgname = data1.rows[i].org_name;
                }
                tipView('orgName-' + i,orgname,'top');
                if(data1.rows[i].project_name!= undefined){
                    var projectname = data1.rows[i].project_name;
                }
                tipView('proFullName-' + i,projectname,'top');
            }
        }		
	});
	//初始化消耗备件明细
	$("#spare_grid").datagrid({ 
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
//加载维修基本信息
function loadMainInfo(repairinfo,msflag){
	$("#detail").attr("src",'${pageContext.request.contextPath}/rm/dm/dev_work/devRepairDetail.jsp?repair_info='+repairinfo+'&msflag='+msflag);
}
//加载消耗备件明细
function loadDetialList(repairinfo){
	$("#spare_grid").datagrid({
		queryParams:{'repairinfo': repairinfo},
		url:'${pageContext.request.contextPath}/rm/dm/getListDataBySrvAndMethod.srq?JCDP_SRV_NAME=DevRepairSrv&JCDP_OP_NAME=queryDevRepairDet',
		onLoadSuccess : function(data) {
			for(var i = 0; i < data.rows.length; i++){
                if(data.rows[i].material_name!= undefined){
                    var materialname = data.rows[i].material_name;
                }
                tipView('matDesc-' + i,materialname,'top');
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
//高级查询
function advanceSearchWindow(){
	window.top.$.JDialog.open('${pageContext.request.contextPath}/rm/dm/dev_work/advanceDevSearch.jsp',{
        win:window,
        width:900,
        height:530,
        title:"设备维修-高级查询",
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
//项目描述简写名称
function proNameFormater(value,row,index){
    if(value&&value.length>16) {
       var filedName = value.substring(0,16)+"...";
       return '<div id="proFullName-'+index+'" style="width:auto;">'+filedName+'</div>';
   }else{
       return value;
   }
}
//单据明细物料说明
function matFormater(value,row,index){
	if(value != "") {
	    return '<div id="matDesc-'+index+'" style="width:auto;">'+value+'</div>';
	 }else{
	    return value;
	 }
}
</script>
</html>
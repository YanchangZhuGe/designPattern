<%@ page contentType="text/html;charset=UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="easyuiAuth" uri="easyuiAuth"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String orgSubId = user.getSubOrgIDofAffordOrg();
	String apply_id=request.getParameter("apply_id"); 
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@include file="/common/include/quotesresource.jsp"%>
<script type="text/javascript" src="<%=contextPath%>/js/devDialogOpen.js"></script>
<title>需求计划</title>
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
					<table id="bill_grid">
						<thead>
							<tr>
								<th nowrap="false" data-options="field:'detail_id',align:'center',hidden:true" width="10">主键</th>
								<th nowrap="false" data-options="field:'material_desc',align:'center',sortable:'true'" formatter='matFormater' width="60">物料描述</th>
								<th nowrap="false" data-options="field:'material_code',align:'center',sortable:'true'" width="20">物料编码</th>
								<th nowrap="false" data-options="field:'apply_number',align:'center',sortable:'true'" width="15">申请数量</th>
								<th nowrap="false" data-options="field:'meas_unit',align:'center',sortable:'true'" width="15">计量单位</th>
								<th nowrap="false" data-options="field:'delivery_date',align:'center',sortable:'true'" width="20">交货日期</th>
								<th nowrap="false" data-options="field:'asse_price',align:'center',sortable:'true'" width="20">评估价格(元)</th>
								<th nowrap="false" data-options="field:'apply_dnum',align:'center',sortable:'true'" width="40">申请文号</th>
								<th nowrap="false" data-options="field:'org_name',align:'center',sortable:'true'" width="30">所属单位</th>
								<th nowrap="false" data-options="field:'contact',align:'center',sortable:'true'" width="20">联系人</th>
								<th nowrap="false" data-options="field:'phone',align:'center',sortable:'true'" width="25">联系方式</th>
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
var apply_id='<%=apply_id%>';
$(function(){
	//设置样式
	$(".only_read").attr("readonly","true");
	$(".only_read").css("border","0").css("color","blue").css("background-color","transparent");
	$("#detail tr").each(function(index){
		if(index%2==0){
			$(this).addClass("datagrid-row-alt");
		}		
	});
	//初始化需求计划明细信息
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
 loadDetialList(apply_id);
});
 
//加载需求计划明细
function loadDetialList(applyid){
	$("#bill_grid").datagrid({
		queryParams:{'applyid': applyid},
		url:'${pageContext.request.contextPath}/rm/dm/getListDataBySrvAndMethod.srq?JCDP_SRV_NAME=ExePlanSrv&JCDP_OP_NAME=queryExePlanDetByApplyNum',
		onLoadSuccess : function(data) {
            for(var i = 0; i < data.rows.length; i++){
                if(data.rows[i].dev_name!= undefined){
                    var devname = data.rows[i].dev_name;
                }
                tipView('matDesc-' + i,devname,'top');
            }
        },
	});
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
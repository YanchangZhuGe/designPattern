<%@ page contentType="text/html;charset=UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="easyuiAuth" uri="easyuiAuth"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String orgSubId = user.getSubOrgIDofAffordOrg();
	String purc_id=request.getParameter("purc_id"); 
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
					<table id="bill_grid">
						<thead>
							<tr>
								<th nowrap="false" data-options="field:'detail_id',align:'center',hidden:true" width="10">主键</th>
								<th nowrap="false" data-options="field:'apply_num',align:'center',sortable:'true'" width="25">需求计划单号</th>								
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
				</div>
			</div>
		</div>
	 
	<div id="win"></div>
</body>
<script type="text/javascript">
var selectTabIndex  =0;
var currentId = "";
var queryParams;
var purc_id='<%=purc_id%>';
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
	loadDetialList(purc_id);
});
 
//加载采购计划明细
function loadDetialList(purcid){
	$("#bill_grid").datagrid({
		queryParams:{'purcid': purcid},
		url:'${pageContext.request.contextPath}/rm/dm/getListDataBySrvAndMethod.srq?JCDP_SRV_NAME=ExePlanSrv&JCDP_OP_NAME=queryExePurcDetByPurcNum',
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
 
</script>
</html>
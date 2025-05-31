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
<title>设备出入库验收</title>
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
								<th data-options="field:'keeping_id',checkbox:true,align:'center'" width="10">主键</th>
								<th data-options="field:'dev_type',align:'center',sortable:'true'" width="20">设备类别</th>
								<th data-options="field:'dev_name',align:'center',sortable:'true'" width="20">设备名称</th>
								<th data-options="field:'dev_tname',align:'center',sortable:'true'" width="20">设备型号</th>
								<th data-options="field:'dev_num',align:'center',sortable:'true'" width="20">号牌号码</th>
								<th data-options="field:'self_num',align:'center',sortable:'true'" width="20">自编号</th>
								<th data-options="field:'dev_sign',align:'center',sortable:'true'" width="20">实物标识号</th>
								<th data-options="field:'thing_type',align:'center',sortable:'true'" width="20">业务类型</th>
								<th data-options="field:'turn_date',align:'center',sortable:'true'" width="20">调配时间</th>
								<th data-options="field:'keeping_date',align:'center',sortable:'true'" width="20">进出库时间</th>
								<th data-options="field:'sub_org_id',align:'center',sortable:'true'" width="20">经办单位</th>
							</tr>
						</thead>
					 </table>
					 <div id="tb2" style="height:28px;">
						<div style="float:left;height:28px;">						
							&nbsp;&nbsp;车牌号码：<input id="q_dev_num" class="input_width query" style="width:100px;float:none;">
							&nbsp;&nbsp;设备类别：<input id="q_dev_type" class="input_width query" style="width:100px;float:none;">
							&nbsp;&nbsp;设备名称：<input id="q_dev_name" class="input_width query" style="width:100px;float:none;">							
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
                	<div id="mixcoll_detail" data-options="fit:true" class="easyui-panel" title="" style="padding:10px;">
					<table id="detail" width="600" height="100"  style="overflow:hidden;"  class="tab_line_height">
					 <tr>
						 <td class="inquire_item">整车卫生：</td>
					     <td class="inquire_form" colspan="3">
					    	<input type="text" id="dev_clean" class="input_width only_read mixcoll" />
					     </td>
					     <td class="inquire_item">牌照数量：</td>
					     <td class="inquire_form" colspan="3">
					    	<input type="text" id="mark_num" class="input_width only_read mixcoll" />
					     </td>
					     <td class="inquire_item">车辆证件数量：</td>
					     <td class="inquire_form" colspan="3">
					    	<input type="text" id="port_num" class="input_width only_read mixcoll" />
					     </td>
					 </tr>
					 <tr>
						 <td class="inquire_item">车钥匙数量：</td>
					     <td class="inquire_form" colspan="3">
					    	<input type="text" id="key_num" class="input_width only_read mixcoll" />
					     </td>
					     <td class="inquire_item">随车工具数量：</td>
					     <td class="inquire_form" colspan="3">
					    	<input type="text" id="tool_num" class="input_width only_read mixcoll" />
					     </td>
					     <td class="inquire_item">防冻液冰点：</td>
					     <td class="inquire_form" colspan="3">
					    	<input type="text" id="freezing_point" class="input_width only_read mixcoll" />
					     </td>
					 </tr>
					 <tr>
						 <td class="inquire_item">备胎数量：</td>
					     <td class="inquire_form" colspan="3">
					    	<input type="text" id="spare_tire_num" class="input_width only_read mixcoll" />
					     </td>
					     <td class="inquire_item">灭火器数量：</td>
					     <td class="inquire_form" colspan="3">
					    	<input type="text" id="fire_extinguisher" class="input_width only_read mixcoll" />
					     </td>
					     <td class="inquire_item">其他缺件登记：</td>
					     <td class="inquire_form" colspan="3">
					    	<input type="text" id="other" class="input_width only_read mixcoll" />
					     </td>
					 </tr>
					 <tr>
						 <td class="inquire_item">存放位置：</td>
					     <td class="inquire_form" colspan="3">
					    	<input type="text" id="keeping_position" style="width:250px;" class="input_width only_read mixcoll" />
					     </td>
					     <td class="inquire_item">设备调拨单号：</td>
					     <td class="inquire_form" colspan="3">
					    	<input type="text" id="dev_turn_num" class="input_width only_read mixcoll" />
					     </td>
					     <td class="inquire_item">签发人：</td>
					     <td class="inquire_form" colspan="3">
					    	<input type="text" id="given_pp" class="input_width only_read mixcoll" />
					     </td>
					 </tr>
					 <tr>
						 <td class="inquire_item">库房经办人：</td>
					     <td class="inquire_form" colspan="3">
					    	<input type="text" id="keeping_pp" class="input_width only_read mixcoll" />
					     </td>
					     <td class="inquire_item">交接经办人：</td>
					     <td class="inquire_form" colspan="3">
					    	<input type="text" id="turn_pp" class="input_width only_read mixcoll" />
					     </td>
					 </tr>
				 </table>
                </div>
                </div>
                <div title="附件" >
					<iframe id="attachement" scrolling="yes" frameborder="0"  src="" style="width:100%;height:100%;"></iframe>
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
					loadMixCollInfo(row.keeping_id);
				}else if(selectTabIndex==1){
					//附件
					loadDocList(row.keeping_id);
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
        	loadMixCollInfo(row.keeping_id);
    	},
		onClickRow:function(index,data){
			currentId = data.keeping_id;
			if(selectTabIndex==0){
				//设置基本信息
				loadMixCollInfo(currentId);
			}else if(selectTabIndex==1){
				//附件
				loadDocList(currentId);
			}
		},
		url:"${pageContext.request.contextPath}/dmsManager/safekeeping/queryKeepingConfInfoList.srq?JCDP_SRV_NAME=DevKeeping&JCDP_OP_NAME=queryKeepingConfInfoViewList"
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
});
//加载附件
function loadDocList(mix_id){
	$("#attachement").attr("src",'${pageContext.request.contextPath}/doc/common/common_doc_list.jsp?relationId='+mix_id);
}   

//加载地震仪器调配信息
function loadMixCollInfo(mix_id){
	if(mix_id==""){
		 $(".mixcoll").each(function(){
			$("#"+this.id).val("");
		});
		return;
	 }
	 //$.messager.progress({title:'请稍后',msg:'数据加载中....'});
	 debugger;
	 $.ajax({
	        type: "POST",
	        url:'${pageContext.request.contextPath}/dmsManager/safekeeping/getKeepingConfInfo.srq?JCDP_SRV_NAME=DevKeeping&JCDP_OP_NAME=getKeepingConfInfo',
	        data:{"keeping_id":mix_id},
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
// 选择组织机构树	 	 
function showOrgTreePage(){
	var returnValue={
		fkValue:"",
		value:""
	}
	window.showModalDialog("${pageContext.request.contextPath}/common/selectOrgSub.jsp",returnValue,"");
	$("#apporgname").val(returnValue.value);
	$("#apporgid").val(returnValue.fkValue);
}

</script>
</html>
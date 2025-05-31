<%@ page contentType="text/html;charset=UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="easyuiAuth" uri="easyuiAuth"%>
<%@page import="java.util.*,com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@taglib prefix="auth" uri="auth"%>
<%@ page import="com.cnpc.jcdp.cfg.BeanFactory"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String orgSubId = user.getSubOrgIDofAffordOrg();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@include file="/common/include/quotesresource.jsp"%>
<title>日常检查</title>
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
					<table id="backapp_grid">
						<thead>
							<tr>
								<th data-options="field:'devinspectioin_id',checkbox:true,align:'center'" width="10">主键</th>
								<th data-options="field:'type',align:'center',hidden:'true'" width="10">类型</th><!-- 隐藏属性 -->
								<th data-options="field:'dev_name',align:'center',sortable:'true'" width="15">设备名称</th>
								<th data-options="field:'dev_model',align:'center',sortable:'true'" width="15">规格型号</th>
								<th data-options="field:'self_num',align:'center',sortable:'true'" width="10">自编号</th>
								<th data-options="field:'license_num',align:'center',sortable:'true'" width="15">牌照号</th>
								<th data-options="field:'dev_sign',align:'center',sortable:'true'" width="25">实物标识号</th>
								<th data-options="field:'t_ins_people',align:'center',sortable:'true'" width="12">检查记录人</th>
								<th data-options="field:'inspectioin_time',align:'center',sortable:'true'" width="15">检查记录时间</th>
								<th data-options="field:'inspectioin_update_time',align:'center',sortable:'true'" width="15">检查更新时间</th>
								<th data-options="field:'create_time',align:'center',sortable:'true'" width="10">创建时间</th>
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
							<a href="####" class="easyui-linkbutton" onclick="openW()"><i class="fa fa-th fa-lg"></i> 详情</a>
							<a href="####" class="easyui-linkbutton" onclick="toAddMixPlanPage()"><i class="fa fa-plus-circle fa-lg"></i> 新增</a>
							<a href="####" class="easyui-linkbutton" onclick="toModifyMixPlanPage()"><i class="fa fa-pencil-square fa-lg"></i> 修改</a>
							<a href="####" class="easyui-linkbutton" onclick="toDelMixPlanPage()"><i class="fa fa-trash-o fa-lg"></i> 删除</a>	
						</div>						
					</div>
				</div>
			</div>
		</div>
		<!-- 页面下半部分 -->
		<div id="center" data-options="region:'center',title:'',split:true">	
			  <div id="tab" class="easyui-tabs" data-options="fit:true,plain:true">
                <div title="设备信息" style="padding:10px;">
                	<div id="backapp_detail" data-options="fit:true" class="easyui-panel" title="" style="padding:10px;">
					<table id="detail" width="600" height="100"  style="overflow:hidden;"  class="tab_line_height">
					<tr>
						 <td class="inquire_item">设备名称：</td>
					     <td class="inquire_form" colspan="3">
					    	<input type="text" id="dev_name" class="input_width only_read backapp" />
					     </td>
					     <td class="inquire_item">规格型号：</td>
					     <td class="inquire_form" colspan="3">
					    	<input type="text" id="dev_model" class="input_width only_read backapp" />
					     </td>
					     <td class="inquire_item">自编号：</td>
					     <td class="inquire_form" colspan="3">
					    	<input type="text" id="self_num" class="input_width only_read backapp" />
					     </td>
					 </tr>
					 <tr>
					 	 <td class="inquire_item">牌照号：</td>
					     <td class="inquire_form" colspan="3">
					    	<input type="text" id="license_num" class="input_width only_read backapp" />
					     </td>
					     <td class="inquire_item">实物标识号：</td>
					     <td class="inquire_form" colspan="3">
					    	<input type="text" id="dev_sign" class="input_width only_read backapp" />
					     </td>
					     <td class="inquire_item">燃油加油量：</td>
					     <td class="inquire_form" colspan="3">
					    	<input type="text" id="oil_num" class="input_width only_read backapp" />
					     </td>
					 </tr>
					  <tr>
						 <td class="inquire_item">钻井进尺：</td>
					     <td class="inquire_form" colspan="3">
					    	<input type="text" id="drilling_num" class="input_width only_read backapp" />
					     </td>
					     <td class="inquire_item">工作小时：</td>
					     <td class="inquire_form" colspan="3">
					    	<input type="text" id="work_hour" class="input_width only_read backapp" />
					     </td>
					     <td class="inquire_item">当日里程：</td>
					     <td class="inquire_form" colspan="3">
					    	<input type="text" id="mileage_today" class="input_width only_read backapp" />
					     </td>
					 </tr>
					  <tr>
					  	 <td class="inquire_item">里程表读数：</td>
					     <td class="inquire_form" colspan="3">
					    	<input type="text" id="mileage_write" class="input_width only_read backapp" />
					     </td>
						 <td class="inquire_item">整改人：</td>
					     <td class="inquire_form" colspan="3">
					    	<input type="text" id="modification_people" class="input_width only_read backapp" />
					     </td>
					     <td class="inquire_item">整改时间：</td>
					     <td class="inquire_form" colspan="3">
					    	<input type="text" id="modification_time" class="input_width only_read backapp" />
					     </td>
					 </tr>	
					<tr>
						<td class="inquire_item">整改结果：</td>
						<td class="inquire_form" colspan="5"><textarea  id="modification_result" name="modification_result" readonly="readonly" class="textarea backapp input_width only_read" style="height:40px"></textarea></td>
					</tr>
					<tr>
						<td class="inquire_item">整改内容：</td>
						<td class="inquire_form" colspan="5"><textarea  id="modification_content" name="modification_content" readonly="readonly" class="textarea backapp input_width only_read" style="height:40px"></textarea></td>
					</tr>
				 </table>
                </div>
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
var orgSubId = "<%=orgSubId%>";

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
			var row = $('#backapp_grid').datagrid('getSelected').devinspectioin_id;
			if(row){
				if(selectTabIndex==0){
					//设置基本信息
					loadMixCollInfo(row);
				}
			}			
		}
	});
	//初始单台设备调配信息
	$("#backapp_grid").datagrid({
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
        	loadMixCollInfo(row.devinspectioin_id);
    	},
		onClickRow:function(index,data){
			currentId = data.devinspectioin_id;
			if(selectTabIndex==0){
				//设置基本信息
				loadMixCollInfo(currentId);
			} 
		},
		queryParams:{//必需参数
			'orgSubId':orgSubId
		},
		url:"${pageContext.request.contextPath}/rm/dm/getListDataBySrvAndMethod.srq?JCDP_SRV_NAME=DevInspectionList&JCDP_OP_NAME=queryDayInspectionList"
	});
});
//加载返还单基本信息
function loadMixCollInfo(devinspectioin_id){
	if(devinspectioin_id==""){
		 $(".backapp").each(function(){
			$("#"+this.id).val("");
		});
		return;
	 }
	 $.ajax({
	        type: "POST",
	        url:'${pageContext.request.contextPath}/dmsManager/safekeeping/getQZMaintain.srq?JCDP_SRV_NAME=DevInspectionList&JCDP_OP_NAME=getDayInspectionInfo',
	        data:{"devinspectioin_id":devinspectioin_id},
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
	        		$(".backapp").each(function(){
	        			var temp = this.id;
	        			$("#"+this.id).val( typeof data[temp] != "undefined" ? data[temp]:"");
	        		});
	        	}else{
	        		$(".backapp").each(function(){
	        			$("#"+this.id).val("");
	        		});
	        	}
	       }
	 });
}

//查看
function openW(){ 
	var row = $('#backapp_grid').datagrid('getSelected');
	if (row){
		if(row.type=="3"){//运输车辆
			popWindow('<%=contextPath%>/dmsManager/safekeeping/deviceIns/searchRcjcYscl.jsp?ids='+row.devinspectioin_id,'950:580');
		}else if(row.type=="1"){//可控震源
		 	popWindow('<%=contextPath%>/dmsManager/safekeeping/deviceIns/searchRcjcKkzy.jsp?ids='+row.devinspectioin_id,'950:580');
		}else if(row.type=="2"){//轻便钻机
		 	popWindow('<%=contextPath%>/dmsManager/safekeeping/deviceIns/searchRcjcQbzj.jsp?ids='+row.devinspectioin_id,'950:580');
		}else if(row.type=="4"){//车装钻机
		 	popWindow('<%=contextPath%>/dmsManager/safekeeping/deviceIns/searchRcjcCzzj.jsp?ids='+row.devinspectioin_id,'950:580');
		}
	}else{
		$.messager.alert('提示','请选择记录!','warning');
	}
}

//添加
function toAddMixPlanPage(){
	popWindow('${pageContext.request.contextPath}/dmsManager/safekeeping/deviceIns/rcjc_add.jsp?flag=add','950:480','-添加检查内容');
}
//修改
function toModifyMixPlanPage(){
	var row = $('#backapp_grid').datagrid('getSelected');
	if (row){
		popWindow('${pageContext.request.contextPath}/dmsManager/safekeeping/deviceIns/rcjc_edit.jsp?devinspectioin_id='+row.devinspectioin_id+'&flag=update&type='+row.type,'950:580','-修改检查内容');
	}else{
		$.messager.alert('提示','请选择记录!','warning');
	}
}

//删除单据
function toDelMixPlanPage(){
	var row = $('#backapp_grid').datagrid('getSelected');
	if (row){
		debugger;
		$.messager.confirm("操作提示", "您确定要执行操作吗？", function (data) {
	        if (data) {
				var retObj = jcdpCallService("DevCommInfoSrv", "deleteRcjcInfo", "devinspectioin_id="+row.devinspectioin_id);
				queryData(cruConfig.currentPage);
			}
	        searchDevData();
		});
	}else{
		$.messager.alert('提示','请选择记录!','warning');
	}
}

//清空查询条件
function clearQueryText(){
	$(".query").val("");
	setFirstPage("#backapp_grid");
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
	$("#backapp_grid").datagrid('reload',queryParams);
}

//简写名称
function comFormater(value,row,index){
    if(value&&value.length>7) {
       var filedName = value.substring(0,7)+"...";
       return '<div id="comFullName-'+index+'" style="width:auto;">'+filedName+'</div>';
   }else{
       return value;
   }
}
</script>
</html>
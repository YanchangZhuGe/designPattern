<%@ page contentType="text/html;charset=UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="easyuiAuth" uri="easyuiAuth"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String subOrgId = user.getSubOrgIDofAffordOrg();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@include file="/common/include/quotesresource.jsp"%>
<title>要素评分</title>
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
		<div id="north" data-options="region:'north',split:true" style="height:365px;">
			<div class="easyui-layout" data-options="fit:true">
				<!-- 页面上半部分的内容 -->
				<div data-options="region:'center',border:false,split:false" > 
					<table id="assess_grid">
						<thead>
							<tr>
								<th data-options="field:'assess_score_id',checkbox:true,align:'center'" width="10">主键</th>
								<th data-options="field:'assess_org_name',align:'center',sortable:'true'" width="60">被审核单位</th>							
								<th data-options="field:'model_name',align:'center',sortable:'true'" width="30">审核类型</th>
								<th data-options="field:'assess_start_date',align:'center',sortable:'true'" width="30">审核开始时间</th>
								<th data-options="field:'assess_end_date',align:'center',sortable:'true'" width="30">审核结束时间</th>
								<th data-options="field:'assess_user_name',align:'center',sortable:'true'" width="20">审核人员</th>
								<th data-options="field:'appdate',align:'center',sortable:'true'" formatter='assessFormater' width="20">评审结果</th>
								<th data-options="field:'state_desc',align:'center',sortable:'true'" formatter='problemFormater' width="20">问题项</th>
							</tr>
						</thead>
					</table>
					<div id="tb2" style="height:28px;">
						<div style="float:left;height:28px;">						
							&nbsp;&nbsp;被审核单位：<input id="assessorgname" class="input_width query" style="width:100px;float:none;">
							&nbsp;&nbsp;审核人员：<input id="assessusername" class="input_width query" style="width:100px;float:none;">
							&nbsp;&nbsp;审核类型：<input id="modeltype" class="input_width query" style="width:100px;float:none;">
						</div>
						<div style="float:left;height:28px;">
							&nbsp;&nbsp;&nbsp;
							<a href="####" class="easyui-linkbutton" onclick="searchDevData()"><i class="fa fa-search fa-lg"></i> 查询</a>
							<a href="####" class="easyui-linkbutton" onclick="clearQueryText()"><i class="fa fa-minus-square fa-lg"></i> 清除</a>
						</div>
						<div style="float:right;height:28px;">
							<easyuiAuth:EasyUIButton functionId="F_C_A_A1" className="fa fa-plus-circle fa-lg" event="toAddAssessPage()" text="新增"></easyuiAuth:EasyUIButton>
							<easyuiAuth:EasyUIButton functionId="F_C_A_E1" className="fa fa-pencil-square fa-lg" event="toModifyAssessPage()" text="修改"></easyuiAuth:EasyUIButton>
							<easyuiAuth:EasyUIButton functionId="F_C_A_D1" className="fa fa-trash-o fa-lg" event="toDelAssessPage()" text="删除"></easyuiAuth:EasyUIButton>
						</div>						
					</div>
				</div>
			</div>
		</div>
		<!-- 页面下半部分 -->
		<div id="center" data-options="region:'center',title:'',split:true">	
			  <div id="tab" class="easyui-tabs" data-options="fit:true,plain:true">
                <div title="基本信息" style="padding:10px;">
                	<div id="assess_detail" data-options="fit:true" class="easyui-panel" title="" style="padding:10px;">
					<table id="detail" width="600" height="100"  style="overflow:hidden;"  class="tab_line_height">
					<tr>
						 <td class="inquire_item">被审核单位：</td>
					     <td class="inquire_form" colspan="3">
					    	<input type="text" id="assess_org_name" class="input_width only_read assess" />
					     </td>
					     <td class="inquire_item">审核类型：</td>
					     <td class="inquire_form" colspan="3">
					    	<input type="text" id="model_name" class="input_width only_read assess" />
					     </td>
					     <td class="inquire_item">审核人员：</td>
					     <td class="inquire_form" colspan="3">
					    	<input type="text" id="assess_user_name" class="input_width only_read assess" />
					     </td>
					 </tr>
					 <tr>
						 <td class="inquire_item">审核开始时间：</td>
					     <td class="inquire_form" colspan="3">
					    	<input type="text" id="assess_start_date" class="input_width only_read assess" />
					     </td>
					     <td class="inquire_item">审核结束时间：</td>
					     <td class="inquire_form" colspan="3">
					    	<input type="text" id="assess_end_date" class="input_width only_read assess" />
					     </td>
					     <td class="inquire_item">创建单位：</td>
					     <td class="inquire_form" colspan="3">
					    	<input type="text" id="create_org_name" class="input_width only_read assess" />
					     </td>
					 </tr>
					  <tr>
						 <td class="inquire_item">创建人：</td>
					     <td class="inquire_form" colspan="3">
					    	<input type="text" id="creator_name" class="input_width only_read assess" />
					     </td>
					     <td class="inquire_item">创建时间：</td>
					     <td class="inquire_form" colspan="3">
					    	<input type="text" id="create_date" class="input_width only_read assess" />
					     </td>
					 </tr>
				 </table>
                </div>
                </div>
                <div title="附件" >
					<iframe id="attachement" scrolling="yes" frameborder="0" src="" style="width:100%;height:100%;"></iframe>
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
	// 下拉框选择控件，下拉框的内容是动态查询数据库信息
 	$('#modeltype').combobox({ 
		url:'<%=contextPath%>/rm/dm/toGetAssessModelType.srq',
		editable:false, //不可编辑状态
		cache: false,
		panelHeight:'auto',
		valueField:'code',   
		textField:'note',
		value:'请选择...'
     }); 
	//如果有行被选中，则加载选中标签的内容
	$('#tab').tabs({
		onSelect: function(title,index){
			selectTabIndex=index;
			var row = $('#assess_grid').datagrid('getSelected');
			if(row){
				if(selectTabIndex==0){
					//设置基本信息
					loadAccessInfo(row.assess_score_id);
				}else if(selectTabIndex==1){
					//附件
					loadDocList(row.assess_score_id);
				}
			}			
		}
	});
	//初始评审信息
	$("#assess_grid").datagrid({ 
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
		onClickRow:function(index,data){
			currentId = data.assess_score_id;
			if(selectTabIndex==0){
				//设置基本信息
				loadAccessInfo(currentId);
			}else if(selectTabIndex==2){
				//附件
				loadDocList(currentId);
			}
		},
		onDblClickRow:function(index,data){
		},
		onLoadSuccess : function(data1) {
        },
		queryParams:{//必需参数
		},
		url:"${pageContext.request.contextPath}/rm/dm/getListDataBySrvAndMethod.srq?JCDP_SRV_NAME=AssessPlatInfoSrv&JCDP_OP_NAME=queryAssessScoreList"
	});
});
//加载基本信息
function loadAccessInfo(assessscoreid){
	if(assessscoreid==""){
		 $(".assess").each(function(){
			$("#"+this.id).val("");
		});
		return;
	 }
	 //$.messager.progress({title:'请稍后',msg:'数据加载中....'}); 
	 $.ajax({
	        type: "POST",
	        url:'${pageContext.request.contextPath}/rm/dm/ajaxRetMapBySrvAndMethod.srq?JCDP_SRV_NAME=AssessPlatInfoSrv&JCDP_OP_NAME=getAssessScoreInfo',
	        data:{"assessscoreid":assessscoreid},
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
	        		$(".assess").each(function(){
	        			var temp = this.id;
	        			$("#"+this.id).val( typeof data[temp] != "undefined" ? data[temp]:"");
	        		});
	        	}else{
	        		$(".assess").each(function(){
	        			$("#"+this.id).val("");
	        		});
	        	}
	       }
	 });
}
//加载附件
function loadDocList(assessscoreid){
	$("#attachement").attr("src",'${pageContext.request.contextPath}/doc/common/common_doc_list.jsp?relationId='+assessscoreid);
}
//添加
function toAddAssessPage(){
	window.location.href = '${pageContext.request.contextPath}/assess/findElementList.srq';	
}
//修改
function toModifyAssessPage(){
	var row = $('#assess_grid').datagrid('getSelected');
	if (row){
		window.location.href = '${pageContext.request.contextPath}/assess/findElementList.srq?flag=up&scoreID='+row.assess_score_id;
	}else{
		$.messager.alert('提示','请选择记录!','warning');
	}
}
//删除单据
function toDelAssessPage(){
	var row = $('#assess_grid').datagrid('getSelected');
	if (row){
		$.messager.confirm("操作提示", "您确定要执行操作吗？", function (data) {
	        if (data) {
				var retObj = jcdpCallService("AssessPlatServ", "delAssessScore", "assessscoreid="+row.assess_score_id);
				if(typeof retObj.datas!="undefined"){
					var delflag = retObj.datas;
					if("3" == delflag){
						$.messager.alert("提示","操作失败!","error");
						return;
					}
					if("0" == delflag){
						$.messager.alert("提示","删除成功!","info");
						searchDevData();
					}
				}
			}
		});
	}else{
		$.messager.alert('提示','请选择记录!','warning');
	}
}
//清空查询条件
function clearQueryText(){
	$(".query").val("");
	$("#modeltype").combobox("setValue","");
	setFirstPage("#assess_grid");
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
	var modelTyle = $("#modeltype").combobox("getValue");
	if(modelTyle != '' && modelTyle != '请选择...'){
		params["modeltype"] = $("#modeltype").combobox("getValue");
	}	
	queryParams = params;
	$("#assess_grid").datagrid('reload',queryParams);
}
//评审结果查看
function assessFormater(value,row,index){
	return '<a href="####" onclick="viewAssessPage(\'' + row.assess_score_id+ '\')"><font color="blue">查看</font></a>';
}
//查看评审结果
function viewAssessPage(assessscoreid){
	if(assessscoreid == ''){
		$.messager.alert("提示","请选择一条记录!","warning");
		return;
	}
	window.location.href='<%=contextPath%>/assess/findScoreReportByID.srq?scoreID='+assessscoreid+'&flag=view';
}
//问题项 查看/编辑
function problemFormater(value,row,index){
	return '<a href="####" onclick="viewAssessMarkPage(\'' + row.assess_score_id+ '\')"><font color="blue">查看</font></a>'
	+ ' / <a href="####" onclick="toMarkScoreSuggestion(\'' + row.assess_score_id+ '\')"><font color="blue">编辑</font></a>';
}
//问题项查看
function viewAssessMarkPage(assessscoreid){
	/* if(assessscoreid == ''){
		$.messager.alert("提示","请选择一条记录!","warning");
		return;
	} */
	window.location.href='<%=contextPath%>/assess/createMarkScoreList.srq?flag=view&scoreID='+assessscoreid;
}
//问题项查看
function toMarkScoreSuggestion(assessscoreid){
	/* if(assessscoreid == ''){
		$.messager.alert("提示","请选择一条记录!","warning");
		return;
	} */
	window.location.href='<%=contextPath%>/assess/toMarkScoreSuggestion.srq?flag=sug&scoreID='+assessscoreid;
}
</script>
</html>
<%@ page contentType="text/html;charset=UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="easyuiAuth" uri="easyuiAuth"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String orgId = user.getCodeAffordOrgID();
	String orgSubId = user.getSubOrgIDofAffordOrg();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@include file="/common/include/quotesresource.jsp"%>
<title>验收通知</title>
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
					<table id="checkapp_grid">
						<thead>
							<tr>
								<th data-options="field:'ck_dmsid',checkbox:true,align:'center'" width="10">主键</th>
								<th data-options="field:'apply_num',align:'center',sortable:'true'" width="30">需求计划单号</th>							
								<th data-options="field:'pact_num',align:'center',sortable:'true'" width="30">合同单号</th>
								<th data-options="field:'ck_company',align:'center',sortable:'true'" formatter='comFormater'  width="50">供货商</th>
								<th data-options="field:'fold_org_name',align:'center',sortable:'true'" formatter='foldFormater' width="40">调入单位</th>
								<th data-options="field:'using_org_name',align:'center',sortable:'true'" formatter='useFormater' width="40">现使用单位</th>
								<th data-options="field:'yar_date',align:'center',sortable:'true'" width="20">预计到货时间</th>
							</tr>
						</thead>
					</table>
					<div id="tb2" style="height:28px;">
						<div style="float:left;height:28px;">						
							&nbsp;&nbsp;需求计划单号：<input id="q_apply_num" class="input_width query" style="width:120px;float:none;">
						</div>
						<div style="float:left;height:28px;">
							&nbsp;&nbsp;&nbsp;
							<a href="####" class="easyui-linkbutton" onclick="searchDevData()"><i class="fa fa-search fa-lg"></i> 查询</a>
							<a href="####" class="easyui-linkbutton" onclick="clearQueryText()"><i class="fa fa-minus-square fa-lg"></i> 清除</a>
						</div>
						<div style="float:right;height:28px;">
							<easyuiAuth:EasyUIButton functionId="ystz_add" className="fa fa-plus-circle fa-lg son" event="toAddMixPlanPage()" text="添加"></easyuiAuth:EasyUIButton>
							<easyuiAuth:EasyUIButton functionId="ystz_upd" className="fa fa-pencil-square fa-lg son" event="toModifyMixPlanPage()" text="修改"></easyuiAuth:EasyUIButton>
							<easyuiAuth:EasyUIButton functionId="ystz_del" className="fa fa-trash-o fa-lg son" event="toDelMixPlanPage()" text="删除"></easyuiAuth:EasyUIButton>
						</div>						
					</div>
				</div>
			</div>
		</div>
		<!-- 页面下半部分 -->
		<div id="center" data-options="region:'center',title:'',split:true">	
			  <div id="tab" class="easyui-tabs" data-options="fit:true,plain:true">
                <div title="基本信息" style="padding:10px;">
                	<div id="checkapp_detail" data-options="fit:true" class="easyui-panel" title="" style="padding:10px;">
					<table id="detail" width="600" height="100"  style="overflow:hidden;"  class="tab_line_height">
					<tr>
						 <td class="inquire_item">需求计划单号：</td>
					     <td class="inquire_form" colspan="3">
					    	<input type="text" id="apply_num" class="input_width only_read checkapp" />
					     </td>
					     <td class="inquire_item">合同号：</td>
					     <td class="inquire_form" colspan="3">
					    	<input type="text" id="pact_num" class="input_width only_read checkapp" />
					     </td>
					     <td class="inquire_item">供应商：</td>
					     <td class="inquire_form" colspan="3">
					    	<input type="text" id="ck_company" class="input_width only_read checkapp" />
					     </td>
					 </tr>
					 <tr>
					 	 <td class="inquire_item">调入单位：</td>
					     <td class="inquire_form" colspan="3">
					    	<input type="text" id="fold_org_name" class="input_width only_read checkapp" />
					     </td>
						 <td class="inquire_item">现使用单位：</td>
					     <td class="inquire_form" colspan="3">
					    	<input type="text" id="using_org_name" class="input_width only_read checkapp" />
					     </td>
					     <td class="inquire_item">预计到货时间：</td>
					     <td class="inquire_form" colspan="3">
					    	<input type="text" id="yar_date" class="input_width only_read checkapp" />
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
			var row = $('#checkapp_grid').datagrid('getSelected');
			if(row){
				if(selectTabIndex==0){
					//设置基本信息
					loadCheckInfo(row.ck_dmsid);
				}else if(selectTabIndex==1){
					//附件
					loadDocList(row.ck_dmsid);
				}
			}			
		}
	});
	//初始验收通知单据信息
	$("#checkapp_grid").datagrid({ 
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
			currentId = data.ck_dmsid;
			if(selectTabIndex==0){
				//设置基本信息
				loadCheckInfo(currentId);
			}else if(selectTabIndex==1){
				//附件
				loadDocList(currentId);
			}
		},
		queryParams:{//必需参数
			'orgId':'<%=orgId%>',
			'orgSubId':'<%=orgSubId%>'
		},
		url:"${pageContext.request.contextPath}/rm/dm/getListDataBySrvAndMethod.srq?JCDP_SRV_NAME=CheckDevNotice&JCDP_OP_NAME=queryCheckConfInfoList",
		onDblClickRow:function(index,data){
		},
		onLoadSuccess : function(data1) {
            for(var i = 0; i < data1.rows.length; i++){
                if(data1.rows[i].ck_company!= undefined){
                    var ckcompany = data1.rows[i].ck_company;
                }
                tipView('comFullName-' + i,ckcompany,'top');
                if(data1.rows[i].fold_org_name!= undefined){
                    var foldorgname = data1.rows[i].fold_org_name;
                }
                tipView('foldFullName-' + i,foldorgname,'top');
                if(data1.rows[i].using_org_name!= undefined){
                    var usingorgname = data1.rows[i].using_org_name;
                }
                tipView('useFullName-' + i,usingorgname,'top');
            }
        }		
	});
});
//加载验收通知基本信息
function loadCheckInfo(ckdmsid){
	if(ckdmsid==""){
		 $(".checkapp").each(function(){
			$("#"+this.id).val("");
		});
		return;
	 }
	 $.ajax({
	        type: "POST",
	        url:'${pageContext.request.contextPath}/rm/dm/ajaxRetMapBySrvAndMethod.srq?JCDP_SRV_NAME=CheckDevNotice&JCDP_OP_NAME=getCheckConfInfo',
	        data:{"ck_dmsid":ckdmsid},
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
	        		$(".checkapp").each(function(){
	        			var temp = this.id;
	        			$("#"+this.id).val( typeof data[temp] != "undefined" ? data[temp]:"");
	        		});
	        	}else{
	        		$(".checkapp").each(function(){
	        			$("#"+this.id).val("");
	        		});
	        	}
	       }
	 });
}
//添加
function toAddMixPlanPage(){
	popWindow('${pageContext.request.contextPath}/dmsManager/check/checknotic_add.jsp?flag=add','800:400','-增加通知');
}
//修改
function toModifyMixPlanPage(){
	var row = $('#checkapp_grid').datagrid('getSelected');
	if (row){
		popWindow('${pageContext.request.contextPath}/dmsManager/check/checknotic_add.jsp?flag=update&ck_dmsid='+row.ck_dmsid,'800:400','-修改通知');
	}else{
		$.messager.alert('提示','请选择记录!','warning');
	}
}
//删除单据
function toDelMixPlanPage(){
	var row = $('#checkapp_grid').datagrid('getSelected');
	if (row){
		$.messager.confirm("操作提示", "您确定要执行删除操作吗？", function (data) {
	    	if(data){
				var retObj = jcdpCallService("CheckDevNotice", "deleteCheckNoticInfo", "ck_dmsid="+row.ck_dmsid);
				if(typeof retObj.operationFlag!="undefined"){
					var dOperationFlag = retObj.operationFlag;
					if(''!=dOperationFlag){
						if("failed"==dOperationFlag){
							$.messager.alert("提示","删除失败!","error");
						}	
						if("success"==dOperationFlag){
							$.messager.alert("提示","删除成功!","warning");
							searchDevData();
						}
					}
				}
	    	}
        });
	}else{
		$.messager.alert('提示','请选择记录!','warning');
	}
}
//加载附件
function loadDocList(ckdmsid){
	$("#attachement").attr("src",'${pageContext.request.contextPath}/doc/common/common_doc_list.jsp?relationId='+ckdmsid);
}
//清空查询条件
function clearQueryText(){
	$(".query").val("");
	setFirstPage("#checkapp_grid");
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
	params["orgId"] = '<%=orgId%>';
	params["orgSubId"] = '<%=orgSubId%>';
	queryParams = params;
	$("#checkapp_grid").datagrid('reload',queryParams);
}
//供货商简写名称
function comFormater(value,row,index){
    if(value&&value.length>16) {
       var filedName = value.substring(0,16)+"...";
       return '<div id="comFullName-'+index+'" style="width:auto;">'+filedName+'</div>';
   }else{
       return value;
   }
}
//调入单位简写名称
function foldFormater(value,row,index){
    if(value&&value.length>16) {
       var filedName = value.substring(0,16)+"...";
       return '<div id="foldFullName-'+index+'" style="width:auto;">'+filedName+'</div>';
   }else{
       return value;
   }
}
//现使用单位简写名称
function useFormater(value,row,index){
    if(value&&value.length>16) {
       var filedName = value.substring(0,16)+"...";
       return '<div id="useFullName-'+index+'" style="width:auto;">'+filedName+'</div>';
   }else{
       return value;
   }
}
</script>
</html>
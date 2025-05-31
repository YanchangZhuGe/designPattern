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
<title>用户管理</title>
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
								<th data-options="field:'user_id',checkbox:true,align:'center'" width="10">主键</th>
								<th data-options="field:'emp_id',align:'center',hidden:true" width="35">emp_id</th>
								<th data-options="field:'login_id',align:'center',sortable:'true'" width="35">登录ID</th>
								<th data-options="field:'user_name',align:'center',sortable:'true'" width="25">用户名</th>
								<th data-options="field:'org_name',align:'center',sortable:'true'" width="90">组织机构</th>
								<th data-options="field:'email',align:'center',sortable:'true'" width="48">邮箱</th>
								<th data-options="field:'usertype',align:'center',sortable:'true'" width="23">用户类型</th>
								<th data-options="field:'login_ip',align:'center',sortable:'true'" width="25">最近登录IP</th>
								<th data-options="field:'last_login_time',align:'center',sortable:'true'" width="35">最近登录时间</th>
								<th data-options="field:'userstatus',align:'center',sortable:'true'" width="10">状态</th>
							</tr>
						</thead>
					</table>
					<div id="tb2" style="height:28px;">
						<div style="float:left;height:28px;">						
							&nbsp;登录ID：<input id="loginid" class="input_width query" style="width:70px;float:none;"/>
							&nbsp;用户名：<input id="username" class="input_width query" style="width:70px;float:none;"/>
							&nbsp;邮箱：<input id="useremail" class="input_width query" type="text" style="width:70px;float:none;"/>
							&nbsp;用户类型：
							<select id="usertype" name="usertype" class="select_width easyui-combobox" data-options="editable:false,panelHeight:'auto'" style="width:80px;" >
					    	    <option value="" selected="selected">--请选择--</option>
								<option value="0">超级管理员</option>
								<option value="2">物探处管理员</option>
								<option value="3">普通用户</option>
					    	</select>
							&nbsp;组织机构：<input id="useorgname" class="input_width query" style="width:80px;float:none;" readonly>
							<input id="usesubid" name="usesubid" class="query" type="hidden" />
							<a href='####' class='easyui-linkbutton' onclick='showOrgTreePage()'><i class='fa fa-sitemap fa-lg'></i>选择</a>
						</div>
						<div style="float:left;height:28px;">
							&nbsp;&nbsp;
							<a href="####" class="easyui-linkbutton" onclick="searchDevData()"><i class="fa fa-search fa-lg"></i> 查询</a>
							<a href="####" class="easyui-linkbutton" onclick="clearQueryText()"><i class="fa fa-minus-square fa-lg"></i> 清除</a>
						</div>
						<div style="float:right;height:28px;">
							<a href='####' class='easyui-linkbutton' onclick='toAddUserPage()'><i class='fa fa-plus-circle fa-lg'></i>添加</a>
							<a href='####' class='easyui-linkbutton' onclick='toEditUserPage()'><i class='fa fa-pencil-square fa-lg'></i>修改</a>
							<a href='####' class='easyui-linkbutton' onclick='toDelUserPage()'><i class='fa fa-trash-o fa-lg'></i>删除</a>
							<a href='####' class='easyui-linkbutton' onclick='toReSetUserPwdPage()'><i class='fa fa-reply fa-lg son'></i>重置密码</a>
							<!-- <a href='####' class='easyui-linkbutton' onclick='expUserListExcel()'><i class='fa fa-file-excel-o fa-lg'></i>导出</a> -->
						</div>
					</div>
				</div>
			</div>
		</div>
		<!-- 页面下半部分 -->
		<div id="center" data-options="region:'center',title:'',split:true">	
			  <div id="tab" class="easyui-tabs" data-options="fit:true,plain:true">
                <div title="基本信息" style="padding:10px;">
                	<div id="mian_detail" data-options="fit:true" class="easyui-panel" title="" style="padding:10px;">
					<table id="detail" width="600" height="100"  style="overflow:hidden;"  class="tab_line_height">
					<tr>
						 <td class="inquire_item">登录ID：</td>
					     <td class="inquire_form" colspan="3">
					    	<input type="text" id="login_id" class="input_width only_read datadetail" />
					     </td>
					     <td class="inquire_item">用户名：</td>
					     <td class="inquire_form" colspan="3">
					    	<input type="text" id="user_name" class="input_width only_read datadetail" />
					     </td>
					     <td class="inquire_item">组织机构：</td>
					     <td class="inquire_form" colspan="3">
					    	<input type="text" id="org_name" class="input_width only_read datadetail" />
					     </td>
					 </tr>
					 <tr>
					 	 <td class="inquire_item">邮箱：</td>
					     <td class="inquire_form" colspan="3">
					    	<input type="text" id="email" class="input_width only_read datadetail" />
					     </td>
						 <td class="inquire_item">最近登录IP：</td>
					     <td class="inquire_form" colspan="3">
					    	<input type="text" id="login_ip" class="input_width only_read datadetail" />
					     </td>
					     <td class="inquire_item">最近登录时间：</td>
					     <td class="inquire_form" colspan="3">
					    	<input type="text" id="last_login_time" class="input_width only_read datadetail" />
					     </td>
					 </tr>
					  <tr>
					     <td class="inquire_item">状态：</td>
					     <td class="inquire_form" colspan="3">
					    	<input type="text" id="userstatus" class="input_width only_read datadetail" />
					     </td>
					     <td class="inquire_item">用户类型：</td>
					     <td class="inquire_form" colspan="3">
					    	<input type="text" id="usertypename" class="input_width only_read datadetail" />
					     </td>
					 </tr>
				 </table>
                </div>
                </div>
                <div title="角色信息" >
                	<table id="detail_grid">
						<thead>
							<tr>
								<th nowrap="false" data-options="field:'user_role_id',checkbox:true,align:'center'" width="30">主键</th>
								<th nowrap="false" data-options="field:'coding_name',align:'center',sortable:'true'" width="40">角色分类</th>
								<th nowrap="false" data-options="field:'role_c_name',align:'center',sortable:'true'" width="40">中文名称</th>
								<th nowrap="false" data-options="field:'role_e_name',align:'center',sortable:'true'" width="30">英文名称</th>
							</tr>
						</thead>
					</table>
					<div id="tb_detail" style="padding:5px;height:24px;">
						<div style="float:right;">
							<a href='####' class='easyui-linkbutton' onclick='toAddUserRolePage()'><i class='fa fa-plus-circle fa-lg'></i>添加</a>
							<a href='####' class='easyui-linkbutton' onclick='toDelUserRolePage()'><i class='fa fa-trash-o fa-lg'></i>删除</a>
							<!-- <a href='####' class='easyui-linkbutton' onclick='expUserRoleExcel()'><i class='fa fa-file-excel-o fa-lg'></i>导出</a> -->
						</div>
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
					loadMainInfo(row.user_id);
				}else if(selectTabIndex == 1){
					//角色信息
					loadMainDetial(row.user_id);
				}
			}			
		}
	});
	//初始用户信息
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
		onSelect:function(index,data){
			currentId = data.user_id;
			if(selectTabIndex==0){
				//设置基本信息
				loadMainInfo(currentId);
			}else if(selectTabIndex == 1){
				//明细信息
				loadMainDetial(currentId);
			}
		},
		queryParams:{//必需参数
			'orgsubid':'<%=orgSubId %>'
		},
		url:"${pageContext.request.contextPath}/rm/dm/getListDataBySrvAndMethod.srq?JCDP_SRV_NAME=AuthEntitySrv&JCDP_OP_NAME=queryUserDetInfo",
		onDblClickRow:function(index,data){
		},
		onLoadSuccess : function(data1) {
        }		
	});
	//初始化详细信息
	$("#detail_grid").datagrid({ 
		method:'post',
		rownumbers:true,
		toolbar:'#tb_detail',
		border:false,
		striped:true,
		singleSelect:false,
		pagination:true,
		fit:true,
		fitColumns:true
	});
	$("#tb2").find("input[type='text']:first").focus();
});
//加载基本信息
function loadMainInfo(userid){
	var returl = "";
	if(userid==""){
		 $(".datadetail").each(function(){
			$("#"+this.id).val("");
		});
		return;
	 }
	 $.ajax({
	        type: "POST",
	        url: '${pageContext.request.contextPath}/rm/dm/ajaxRetMapBySrvAndMethod.srq?JCDP_SRV_NAME=AuthEntitySrv&JCDP_OP_NAME=getUserMainInfo',
	        data:{"userid":userid},
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
	        		$(".datadetail").each(function(){
	        			var temp = this.id;
	        			$("#"+this.id).val( typeof data[temp] != "undefined" ? data[temp]:"");
	        		});
	        	}else{
	        		$(".datadetail").each(function(){
	        			$("#"+this.id).val("");
	        		});
	        	}
	       }
	 });
}
//加载角色信息
function loadMainDetial(detid){
	$("#detail_grid").datagrid({
		queryParams:{'userid': detid},
		url:'${pageContext.request.contextPath}/rm/dm/getListDataBySrvAndMethod.srq?JCDP_SRV_NAME=AuthEntitySrv&JCDP_OP_NAME=queryUserRoles'
	});
}
//新增用户
function toAddUserPage(){
	editUrl = '${pageContext.request.contextPath}/ibp/auth2/user/editUser.jsp?addupflag=add';
	popWindow(editUrl,'900:520',"-填写用户信息");
}
//修改用户
function toEditUserPage(){
	var row = $('#main_grid').datagrid('getSelected');
	if (row){
		var retObj = jcdpCallService("AuthEntitySrv", "opUserInfo", "opflag=mod&loginid="+row.login_id+"&empid="+row.emp_id+"&userid="+row.user_id);
		if(typeof retObj.datas!="undefined"){
			var delflag = retObj.datas;
			if("4" == delflag || "5" == delflag){
				$.messager.alert("提示","不能对超级管理员做任何操作!","warning");
				return;
			}
		}
		editUrl = '${pageContext.request.contextPath}/ibp/auth2/user/editUser.jsp?addupflag=up&userid='+row.user_id;
		popWindow(editUrl,'900:520',"-修改用户信息");
	}else{
		$.messager.alert('提示','请选择记录!','warning');
	}
}
//删除用户
function toDelUserPage(){
	var row = $('#main_grid').datagrid('getSelected');
	if (row){
		$.messager.confirm("操作提示", "您确定要执行操作吗？", function (data) {
	        if (data) {
				var retObj = jcdpCallService("AuthEntitySrv", "opUserInfo", "opflag=del&loginid="+row.login_id+"&empid="+row.emp_id+"&userid="+row.user_id);
				if(typeof retObj.datas!="undefined"){
					var delflag = retObj.datas;
					if("4" == delflag || "5" == delflag){
						$.messager.alert("提示","不能对超级管理员做任何操作!","warning");
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
//重置用户密码
function toReSetUserPwdPage(){
	var row = $('#main_grid').datagrid('getSelected');
	if (row){
		$.messager.confirm("操作提示", "您确定要执行操作吗？", function (data) {
	        if (data) {
				var retObj = jcdpCallService("AuthEntitySrv", "opUserInfo", "opflag=pwd&loginid="+row.login_id+"&empid="+row.emp_id+"&userid="+row.user_id);
				if(typeof retObj.datas!="undefined"){
					var delflag = retObj.datas;
					if("4" == delflag || "5" == delflag){
						$.messager.alert("提示","不能对 '超级管理员' 做任何操作!","warning");
						return;
					}
					if("0" == delflag){
						$.messager.alert("提示","重置成功!","info");
						searchDevData();
					}
				}
			}
		});
	}else{
		$.messager.alert('提示','请选择记录!','warning');
	}
}
//新增用户角色
function toAddUserRolePage(){
	var row = $('#main_grid').datagrid('getSelected');
	if (row){
		var retObj = jcdpCallService("AuthEntitySrv", "opUserInfo", "opflag=mod&loginid="+row.login_id+"&empid="+row.emp_id+"&userid="+row.user_id);
		if(typeof retObj.datas!="undefined"){
			var delflag = retObj.datas;
			if("4" == delflag || "5" == delflag){
				$.messager.alert("提示","不能对超级管理员做任何操作!","warning");
				return;
			}
		}
		editUrl = '${pageContext.request.contextPath}/ibp/auth2/role/roleListSelect.jsp?userid='+row.user_id;
		popWindow(editUrl,'900:520',"-新增用户角色");
	}else{
		$.messager.alert('提示','请选择记录!','warning');
	}
}
//删除用户角色
function toDelUserRolePage(){
	var idinfos = [];
	var rows = $('#detail_grid').datagrid('getSelections');
	for(var i=0; i<rows.length; i++){
		idinfos.push(rows[i].user_role_id);
	}
    if (idinfos == '') {
		$.messager.alert("提示","请选择一条记录!","warning");
		return;
	}
    var row = $('#main_grid').datagrid('getSelected');
	if (row){
		$.messager.confirm("操作提示", "您确定要执行操作吗？", function (data) {
		     if (data) {
				var retObj = jcdpCallService("AuthEntitySrv", "opUserInfo", "opflag=dr&loginid="+row.login_id+"&empid="+row.emp_id+"&userroleids="+idinfos);
				if(typeof retObj.datas!="undefined"){
					var delflag = retObj.datas;
					if("4" == delflag || "5" == delflag){
						$.messager.alert("提示","不能对超级管理员做任何操作!","warning");
						return;
					}
					if("0" == delflag){
						$.messager.alert("提示","删除成功!","info");
						$("#detail_grid").datagrid('reload',{'userid': row.user_id});
					}
				}
			}
		});
	}else{
		$.messager.alert('提示','请选择用户!','warning');
	}
}
//导出用户
function expUserListExcel(){
	$.messager.alert('提示','此功能正在建设中，敬请期待...','info');
	//window.location.href='<%=contextPath%>/rm/dm/toGetDevExcel.srq?devid='+info[0];	
}
//清空查询条件
function clearQueryText(){
	$(".query").val("");
	$("#usertype").combobox("setValue","");
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
	params["orgsubid"] = '<%=orgSubId %>';
	params["usertype"] = $("#usertype").combobox("getValue");
	queryParams = params;
	$("#main_grid").datagrid('reload',queryParams);
}
// 选择组织机构树	 	 
function showOrgTreePage(){
	var returnValue={
		fkValue:"",
		value:""
	}
	window.showModalDialog("<%=contextPath%>/common/selectOrgSub.jsp",returnValue,"");
	$("#useorgname").val(returnValue.value);
	$("#usesubid").val(returnValue.fkValue);
	tipView('useorgname',returnValue.value,'bottom');
}
</script>
</html>
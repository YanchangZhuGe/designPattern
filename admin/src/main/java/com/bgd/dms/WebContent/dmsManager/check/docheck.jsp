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
<title>设备验收</title>
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
								<th data-options="field:'ck_id',checkbox:true,align:'center'" width="10">主键</th>
								<th data-options="field:'ck_cid',align:'center',sortable:'true'" width="20">验收单号</th>
								<th data-options="field:'ck_company',align:'center',sortable:'true'" width="30">供应商</th>
								<th data-options="field:'pact_num',align:'center',sortable:'true'" width="15">合同号</th>
								<th data-options="field:'ck_sectors',align:'center',sortable:'true'" width="15">验收单位</th>
								<th data-options="field:'ck_status',align:'center',sortable:'true'" width="15">计划状态</th>
								<th data-options="field:'ck_outcome',align:'center',sortable:'true'" width="15">验收结果</th>
								<th data-options="field:'ck_date',align:'center',sortable:'true'" width="15">验收时间</th>
							</tr>
						</thead>
					</table>
					<div id="tb2" style="height:28px;">
						<div style="float:left;height:28px;">						
							&nbsp;&nbsp;验收单号：<input id="q_ck_cid" class="input_width query" style="width:75px;float:none;">
						</div>
						<div style="float:left;height:28px;">
							&nbsp;&nbsp;&nbsp;
							<a href="####" class="easyui-linkbutton" onclick="searchDevData()"><i class="fa fa-search fa-lg"></i> 查询</a>
							<a href="####" class="easyui-linkbutton" onclick="clearQueryText()"><i class="fa fa-minus-square fa-lg"></i> 清除</a>
						</div>
						<div style="float:right;height:28px;">
							<easyuiAuth:EasyUIButton functionId="sbys_ys" className="fa fa-check-square-o fa-lg" event="toModifyMixPlanPage()" text="验收"></easyuiAuth:EasyUIButton>
							 
						</div>						
					</div>
				</div>
			</div>
		</div>
		<!-- 页面下半部分 -->
		<div id="center" data-options="region:'center',title:'',split:true">	
			  <div id="tab" class="easyui-tabs" data-options="fit:true,plain:true">
                <div title="设备列表">
                	<table id="backinfo_grid">
						<thead>
							<tr>
								<th nowrap="false" data-options="field:'dev_id',align:'center',hidden:true" width="30">主键</th>
								<th nowrap="false" data-options="field:'dev_name',align:'center',sortable:'true'" width="20">设备名称</th>
								<th nowrap="false" data-options="field:'dev_model',align:'center',sortable:'true'" width="40">型号</th>
								<th nowrap="false" data-options="field:'dev_num',align:'center',sortable:'true'" width="10">数量</th>
								<th nowrap="false" data-options="field:'dev_producer',align:'center',sortable:'true'" width="50">生产厂家</th>
								<th nowrap="false" data-options="field:'dev_type',align:'center',sortable:'true'" width="10">计量单位</th>
							</tr>
						</thead>
					</table>
                </div>
                <div title="验收小组" >
					<table id="backinfos_grid">
						<thead>
							<tr>
								<th nowrap="false" data-options="field:'ps_id',align:'center',hidden:true" width="20">主键</th>
								<th nowrap="false" data-options="field:'ps_name',align:'center',sortable:'true'" width="15">姓名</th>
								<th nowrap="false" data-options="field:'ps_sex',align:'center',sortable:'true'" width="15">性别</th>
								<th nowrap="false" data-options="field:'ps_sectors',align:'center',sortable:'true'" width="40">所在单位</th>
								<th nowrap="false" data-options="field:'ps_job',align:'center',sortable:'true'" width="20">职称</th>
							</tr>
						</thead>
					</table>
                </div>
                <div title="验收内容" >
					<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info">
						<tr>
							<td class="bt_info_even">序号</td> 
							<td class="bt_info_odd">验收步骤</td>
							<td class="bt_info_odd">验收要点</td>
						</tr>
						<tr>
							<td class="bt_info_even">1</td> 
							<td class="bt_info_odd">开箱前检查</td>
							<td class="bt_info_odd">开箱前依据箱单、运单检查到货件数，名称是否相符，外包装是否有破损，裸装设备要检查外观是否有缺损和腐蚀</td>
						</tr>
						<tr>
							<td class="bt_info_even">2</td> 
							<td class="bt_info_odd">开箱清点</td>
							<td class="bt_info_odd">依据装箱单检查，核对设备，附件，随机配件，专业工具及及随机资料等是否相符，是否有受潮、锈蚀等受损迹象，核实到货实物与订货合同是否一致</td>
						</tr>
						<tr>
							<td class="bt_info_even">3</td> 
							<td class="bt_info_odd">性能指标测试</td>
							<td class="bt_info_odd">按照合同约定和设备出厂的有关指标、性能等技术参数对设备和附件进行性能指标测试</td>
						</tr>
						<tr>
							<td class="bt_info_even">4</td> 
							<td class="bt_info_odd">验证</td>
							<td class="bt_info_odd">验收核对随机证件及相关资料</td>
						</tr>
					</table>
                </div>
                <div title="供货商评价" style="padding:10px;">
                	<div id="checkapp_detail" data-options="fit:true" class="easyui-panel" title="" style="padding:10px;">
                	<form name="form1" id="form1" method="post" action="">
						<table id="csiInfo" width="100" height="100"  style="overflow:hidden;"  class="tab_line_height">
							 <tr>
							 	 <input type="hidden" id="csi_id" name="csi_id" value="" class="main"/>
								 <input type="hidden" id="ck_id" name="ck_id" vlaue="" class="main"/>
								 <td class="inquire_item">验收单号：</td>
							     <td>
							    	<input type="text" id="ck_cid" class="easyui-validatebox only_read main" style="width:100%"/>
							     </td>
							     <td class="inquire_item">供货商：</td>
							     <td>
							    	<input type="text" id="ck_company" class="easyui-validatebox only_read main" style="width:100%"/>
							     </td>
							     <td class="inquire_item">满意度：</td>
							     <td>
							    	<select name="csi" id="csi" class="easyui-combobox only_read main" style="width:200px">
										<option value=”0”>非常满意</option>
										<option value=”1”>满意</option>
										<option value=”2”>一般</option>
										<option value=”3”>不满意</option>
										<option value=”4”>非常不满意</option>
									</select>
							     </td>
							 </tr>
					 	</table>
					 	</form>
					 	<div id="oper_div">
				    		<span class="tj_btn"><a href="####" id="submitButton" onclick="submitInfo()"></a></span>
       						<span class="gb_btn"><a href="####" onclick="newClose()"></a></span>
				    	</div>
                	</div>
                </div>  
                <div title="上报资料" >
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
var flag = "";
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
			var row = $('#backapp_grid').datagrid('getSelected').ck_id;
			if(row){
				if(selectTabIndex==0){
					//验收设备
					loadMixCollInfo(row);
				}else if(selectTabIndex == 1){
					// 验收小组
					loadMixCollDetial(row);
				}else if(selectTabIndex == 3){
					//供货商评价
					loadCsiInfo(row);
				}else if(selectTabIndex == 4){
					//上报资料
					loadDocList(row);
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
		onClickRow:function(index,data){
			currentId = data.ck_id;
			if(selectTabIndex==0){
				//设置基本信息
				loadMixCollInfo(currentId);
			}else if(selectTabIndex == 1){
				// 保养项目
				loadMixCollDetial(currentId);
			}else if(selectTabIndex == 3){
				//供货商评价
				loadCsiInfo(currentId);
			}else if(selectTabIndex == 4){
				//上报资料
				loadDocList(currentId);
			} 
		},
		queryParams:{//必需参数
			'orgSubId':orgSubId
		},
		url:"${pageContext.request.contextPath}/rm/dm/getListDataBySrvAndMethod.srq?JCDP_SRV_NAME=CheckDevReady&JCDP_OP_NAME=queryCheckReadyInfoList"
	});
	//初始化保养项目信息,消耗备件信息
	$("#backinfo_grid").datagrid({
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
	//初始化保养项目信息,消耗备件信息
	$("#backinfos_grid").datagrid({
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
	$('#csi').combobox({    
		panelHeight:'auto',
		editable:false
    });  
});
function loadCsiInfo(ck_id){
	var retObj = jcdpCallService("CheckPersonDev", "getCheckCsiInfo", "ck_id="+ck_id);
	if(typeof retObj.data!="undefined"){
		var data = retObj.data;
		$(".main").each(function(){
			var temp = this.id;
			$("#"+temp).val(data[temp] != undefined ? data[temp]:"");
			if (temp == 'csi'){
				$('#csi').combobox('setValue',data[temp] != undefined ? data[temp]:"")
			}
		});
		
		if(retObj.data.csi=='' || retObj.data.csi=="undefined" || retObj.data.csi==null){
			$("#csi").val("5");
			flag ="add";
		}else{
			flag ="update";
			$("#csi").val(retObj.data.csi);
		} 
	}
}
//加载附件
function loadDocList(ck_id){
	$("#attachement").attr("src",'${pageContext.request.contextPath}/doc/common/common_doc_list.jsp?relationId='+ck_id);
}
//加载验收设备基本信息
function loadMixCollInfo(ck_id){
	$("#backinfo_grid").datagrid({
		queryParams:{'ck_id': ck_id},
		url:"${pageContext.request.contextPath}/rm/dm/getListDataBySrvAndMethod.srq?JCDP_SRV_NAME=CheckPersonDev&JCDP_OP_NAME=queryCheckDevList",
	});
}
// 加载验收小组基本信息
function loadMixCollDetial(ck_id){
	$("#backinfos_grid").datagrid({
		queryParams:{'ck_id': ck_id},
		url:"${pageContext.request.contextPath}/rm/dm/getListDataBySrvAndMethod.srq?JCDP_SRV_NAME=CheckPersonDev&JCDP_OP_NAME=queryCheckPersonList",
	});
}
//添加
function toAddMixPlanPage(){
	popWindow('${pageContext.request.contextPath}/dmsManager/check/docheck_add.jsp',"950:580","-填写设备验收单");
}
//修改
function toModifyMixPlanPage(){
	var row = $('#backapp_grid').datagrid('getSelected');
	if (row){
		popWindow('${pageContext.request.contextPath}/dmsManager/check/docheck_add.jsp?flag=update&ck_id='+row.ck_id ,'950:580','-修改设备验收单');
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
				var retObj = jcdpCallService("DevQZMaintainList", "delQZDevMaintenance", "ck_id="+row.ck_id);
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

//保存
function submitInfo(){
	var ck_cid = $.trim($("#ck_cid").val());
	var ck_company = $.trim($("#ck_company").val());
	var csi = $.trim($("#csi").val());
	if(ck_cid.length<=0){
		$.messager.alert("提示","验收单号不能为空!","warning");
		return;
	}
	if(ck_company.length<=0){
		$.messager.alert("提示","供货商不能为空!","warning");
		return;
	}
	if(csi.length<=0){
		$.messager.alert("提示","满意度不能为空!","warning");
		return;
	}
	$.messager.confirm("操作提示", "您确定要执行操作吗？", function (data) {
        if (data) {
        	$.messager.progress({title:'请稍后',msg:'数据保存中....'});
			$("#submitButton").attr({"disabled":"disabled"});
			document.getElementById("form1").action = "<%=contextPath%>/dmsManager/check/saveOrUpdateCheckCsiInfo.srq?flag="+flag;
			document.getElementById("form1").submit();
        }
    });
}

</script>
</html>
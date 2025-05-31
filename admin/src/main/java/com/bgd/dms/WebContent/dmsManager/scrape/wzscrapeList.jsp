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

<title>物料报废查询</title>
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
								<th data-options="field:'wz_id',checkbox:true,align:'center',dc:false" width="10">主键</th>
								<th data-options="field:'wz_name',align:'center',sortable:'true'" width="30">物料名称</th>
								<th data-options="field:'wz_prickie',align:'center',sortable:'true'" width="8">单位</th>
								<th data-options="field:'wz_price',align:'center'" width="10">单价</th>
								<th data-options="field:'wz_warehouse',align:'center',sortable:'true'" width="25">仓位</th>
								<th data-options="field:'wz_entrepot',align:'center',sortable:'true'" width="15">库位</th>
								<th data-options="field:'wz_slotting',align:'center',sortable:'true'" width="10">新库位</th>
								<th data-options="field:'wz_type',align:'center'" width="20">物料类型</th>
								<th data-options="field:'wz_from',align:'center',sortable:'true'" width="15">进口/国产</th>
								<th data-options="field:'scrapetime',align:'center',sortable:'true'" width="45" >报废年限</th>
								<th data-options="field:'remark',align:'center',sortable:'true'" width="45" >备注</th>
							</tr>
						</thead>
					 </table>
					 <div id="tb2" style="height:28px;">
						<div style="float:left;height:28px;">
						 
							&nbsp;&nbsp;物料名称：<input id="query_wz_name" name="wz_name" class="input_width query" style="width:80px;float:none;">		
							&nbsp;&nbsp;物料类型：<input id="query_wz_type" name="wz_type" class="input_width query" style="width:80px;float:none;">		
							
							 						
							   <!-- <td class="ali_cdn_name query">所属单位</td>
			    <td class="ali_cdn_input" style="width:110px;">
			    	<input id="s_own_org_name" name="s_own_org_name" type="text" />
			    </td>
			    <td class="ali_cdn_input" style="width:50px;">
					<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="showOrgTreePage()"  />
					<input id="owning_org_id" name="owning_org_id" class="" type="hidden" />
			    </td> -->
						</div>
						<div style="float:left;height:28px;">
							&nbsp;&nbsp;&nbsp;
							<a href="####" class="easyui-linkbutton" onclick="searchDevData()"><i class="fa fa-search fa-lg"></i> 查询</a>
							<a href="####" class="easyui-linkbutton" onclick="clearQueryText()"><i class="fa fa-minus-square fa-lg"></i> 清除</a>
							<a href="####" class="easyui-linkbutton" style="display: none;" onclick="newSearch()"><i class="fa fa-filter fa-lg"></i>高级查询</a>							
						</div>
						<div style="float:right;height:28px; display:none;">
						
							<a href="####" class="easyui-linkbutton" onclick="downloadModel('dev_model','特种设备导入')"><i class="fa fa-download fa-lg"></i> 设备模板</a>
							<a href="####" class="easyui-linkbutton" onclick="toAddInPlanPage()"><i class="fa fa-plus-circle fa-lg"></i> 添加</a>
							<a href="####" class="easyui-linkbutton" onclick="toEdit()"><i class="fa fa-pencil-square fa-lg"></i> 修改</a>	
							<a href="####" class="easyui-linkbutton" onclick="toDelMixPlanPage()"><i class="fa fa-trash-o fa-lg"></i> 删除</a>	
							<a href="####" class="easyui-linkbutton" onclick="excelDataAdd()"><i class="fa fa-upload fa-lg"></i> 导入</a>						
						    <a href="####" class="easyui-linkbutton" onclick="exportDatForEasyUI('mixcoll_grid','特种设备',1,999999,'<%=contextPath%>')"><i class="fa fa-file-excel-o fa-lg"></i> 导出</a>
						    <easyuiAuth:EasyUIButton functionId="devSpecial_check_add" className="fa fa-file-word-o" event="checkInfo()" text="日常检查"></easyuiAuth:EasyUIButton>
						</div>						
					</div>
				</div>
			</div>
		</div>
		<!-- 页面下半部分 -->
		<div id="center" data-options="region:'center',title:'',split:true" >	
			  <div id="tab" class="easyui-tabs" data-options="fit:true,plain:true" >
			   <div title="基本信息" style="padding:10px;">
					<table id="detail" width="600" height="100"  style="overflow:hidden;"  class="tab_line_height">
					<tr>
						 <td class="inquire_item">物料名称：</td>
					     <td class="inquire_form" colspan="3">
					    	<input type="text" id="wz_name" class="input_width only_read datadetail" />
					     </td>
					     <td class="inquire_item">物料ID：</td>
					     <td class="inquire_form" colspan="3">
					    	<input type="text" id="wz_id" class="input_width only_read datadetail" />
					     </td>
					     <td class="inquire_item">单位：</td>
					     <td class="inquire_form" colspan="3">
					    	<input type="text" id="wz_prickie" class="input_width only_read datadetail" />
					     </td>
					 </tr>
					 <tr>
					 	 <td class="inquire_item">单价：</td>
					     <td class="inquire_form" colspan="3">
					    	<input type="text" id="wz_price" class="input_width only_read datadetail" />
					     </td>
						 <td class="inquire_item">仓位：</td>
					     <td class="inquire_form" colspan="3">
					    	<input type="text" id="wz_warehouse" class="input_width only_read datadetail" />
					     </td>
					     <td class="inquire_item">库位：</td>
					     <td class="inquire_form" colspan="3">
					    	<input type="text" id="wz_entrepot" class="input_width only_read datadetail" />
					     </td>
					 </tr>
					  <tr>
					     <td class="inquire_item">新仓库：</td>
					     <td class="inquire_form" colspan="3">
					    	<input type="text" id="wz_slotting" class="input_width only_read datadetail" />
					     </td>
					     <td class="inquire_item">物料类型：</td>
					     <td class="inquire_form" colspan="3">
					    	<input type="text" id="wz_type" class="input_width only_read datadetail" />
					     </td>
					     <td class="inquire_item">进口/国产：</td>
					     <td class="inquire_form" colspan="3">
					    	<input type="text" id="wz_from"   class="input_width only_read datadetail" />
					     </td>
					 </tr>
					 <tr>
					     <td class="inquire_item">设备名称：</td>
					     <td class="inquire_form" colspan="3">
					    	<input type="text" id="device_name" class="input_width only_read datadetail" />
					     </td>
					     <td class="inquire_item">报废年限：</td>
					     <td class="inquire_form" colspan="3">
					    	<input type="text" id="scrapetime" class="input_width only_read datadetail" />
					     </td>
					     <td class="inquire_item">是否处置：</td>
					     <td class="inquire_form" colspan="3">
					    	<input type="text" id="handle_flag" class="input_width only_read datadetail" />
					     </td>
					 </tr>
					 <tr>
					     <td class="inquire_item">备注：</td>
					     <td class="inquire_form" colspan="3">
					    	<input type="text" id="remark" class="input_width only_read datadetail" />
					     </td>
					 </tr>
					 
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
	//$("#detail_grid").datagrid('reload');
}
//查询及返回刷新
function searchDevData1(obj){
  
    $('#mixcoll_grid').datagrid({ queryParams: obj });   //点击搜索
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
				 
				 
				}else if(selectTabIndex==1){
				 
					 
				}else if(selectTabIndex == 2){
				 
				 
				}else if (selectTabIndex == 3){
				 
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
		pageList: [10, 20, 50, 100,200],
		onClickRow:function(index,data){
			currentId = data.scrape_detailed_wz_id;
			if(selectTabIndex==0){
				baseinfo(currentId);
			}else if(selectTabIndex==1){
			 	 
			}else if(selectTabIndex==2){			
			  
			}else if (selectTabIndex == 3){
				//电梯维保
			 
			}
		},
		url:"${pageContext.request.contextPath}/dmsManager/safekeeping/queryKeepingConfInfoList.srq?JCDP_SRV_NAME=ScrapeSrvNew&JCDP_OP_NAME=queryWZScrapeList",
		 
	});
	});
	 

 
	 //加载特种设备基本信息
	function baseinfo(devaccid){
		if(devaccid==""){
			 $(".datadetail").each(function(){
				$("#"+this.id).val("");
			});
			return;
		 }
		 $.ajax({
		        type: "POST",
		        url: '${pageContext.request.contextPath}/rm/dm/ajaxRetMapBySrvAndMethod.srq?JCDP_SRV_NAME=ScrapeSrvNew&JCDP_OP_NAME=getWZScrapeMainInfo',
		        data:{"devaccid":devaccid},
		        dataType:"json",
		        error: function(request) {
		        	$.messager.alert('提示','查询数据出错...','error');
		        },
		        success: function(ret) {
		        	var data = "";
		        	debugger;
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
	var row = $('#mixcoll_grid').datagrid('getSelected');
	//组织查询条件
	var params = {};
	$(".query").each(function(){
		if($(this).val()!=""){
			params[$(this).attr("id")] = $(this).val();
		}
	});
	queryParams = params;
	$("#mixcoll_grid").datagrid('reload',queryParams);
	//组织查询条件
		var params1 = {};
		params1['dev_acc_id'] =row.dev_acc_id;
	$("#check_grid").datagrid('reload',params1);
	$("#dtbywx_grid").datagrid('reload',params1);
	 
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
//导入
	function excelDataAdd(){
		popWindow('<%=contextPath%>/rm/dm/devSpecial/devExcelAdd.jsp','800:520',"-导入设备");
	}
	//下载模板
	function downloadModel(modelname,filename){
		filename = encodeURI(filename);
		filename = encodeURI(filename);
		window.location.href="<%=contextPath%>/rm/dm/xlsmodel/download.jsp?path=/rm/dm/devSpecial/"+modelname+".xlsx&filename="+filename+".xlsx";
	}
	 
	 
	 
	 
	 
	 
	/**
	 * 选择组织机构树
	 */	 
	function showOrgTreePage(){
		var returnValue={
			fkValue:"",
			value:""
		}
		window.showModalDialog("<%=contextPath%>/common/selectOrgSub.jsp",returnValue,"");
		document.getElementById("s_own_org_name").value = returnValue.value;
		
		//var orgId = strs[1].split(":");
		document.getElementById("owning_org_id").value = returnValue.fkValue;
	}
	//加载审验信息
	function loadMainDetial(detid){	 
		if(typeof(detid)!="undefined"&&detid!=null)  {
			$("#detail_grid").datagrid({
				queryParams:{'dev_acc_id': detid},
				url:"${pageContext.request.contextPath}/dmsManager/safekeeping/queryKeepingConfInfoList.srq?JCDP_SRV_NAME=DevInfoConf&JCDP_OP_NAME=queryListOfDEVSPECIAL"
			});	 
		}	
	}
	//加载维保信息
	function loadbywxDetial(detid){	 
		if(typeof(detid)!="undefined"&&detid!=null)  {
			$("#dtbywx_grid").datagrid({
				queryParams:{'dev_acc_id': detid},
				url:"${pageContext.request.contextPath}/dmsManager/safekeeping/queryKeepingConfInfoList.srq?JCDP_SRV_NAME=DevInfoConf&JCDP_OP_NAME=queryListOfDtbywx"
			});		 
		}	
	}
	 
</script>
</html>
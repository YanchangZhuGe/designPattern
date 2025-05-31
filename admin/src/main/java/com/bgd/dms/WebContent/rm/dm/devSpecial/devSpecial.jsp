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

<title>特种设备管理</title>
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
		<div id="north" data-options="region:'north',split:true" >
			<div class="easyui-layout" data-options="fit:true">
				<!-- 页面上半部分的内容 -->
				<div data-options="region:'center',border:false,split:false" style="width:700px;"> 
				
					<table id="mixcoll_grid" style="height:330px;">
					 
							 
								<thead data-options="frozen:true">
								<tr>
								<th data-options="field:'dev_acc_id',resizable:false,checkbox:true,align:'center',dc:false,width:10">主键</th>
								<th data-options="field:'dev_name',resizable:false,align:'center',sortable:'true' , width:200">设备名称</th>
								<th data-options="field:'dev_model',resizable:false,align:'center',sortable:'true' , width:200">设备型号</th>
								<th data-options="field:'dev_coding',resizable:false,align:'center',width:160">ERP编号</th>
								</tr>
								</thead>
								
								<thead>
								<tr>
								<th data-options="field:'dev_num',resizable:false,align:'center',sortable:'true',width:250">出厂/管道编号</th>
								<th data-options="field:'coding_name',resizable:false,align:'center',sortable:'true',width:100">设备状态</th>
								<th data-options="field:'installtion_place',resizable:false,align:'center',sortable:'true',width:300"  >设备安装地点</th>
								<th data-options="field:'registration_code',resizable:false,align:'center',width:220"  >注册码</th>
								<th data-options="field:'zc',resizable:false,align:'center',sortable:'true',width:100">注册状态</th>
								<th data-options="field:'org_name',resizable:false,align:'center',sortable:'true',width:350" formatter="formatOrgName">所属单位</th>
								<th data-options="field:'org_name1',resizable:false,align:'center',sortable:'true',width:350" formatter="formatOrgName">管理单位</th>
								<th data-options="field:'dev_type',resizable:false,align:'center',sortable:'true',hidden:true,dc:false">设备类型</th>
								<th data-options="field:'dev_type1',resizable:false,align:'center',sortable:'true',hidden:true,dc:false"  >设备类型</th>
								<th data-options="field:'producting_date',resizable:false,align:'center',sortable:'true',width:250">投产日期</th>
								<th data-options="field:'asset_value',resizable:false,align:'center',sortable:'true',width:250">资产原值</th>
								<th data-options="field:'next_date',resizable:false,align:'center',sortable:'true',width:225">下次检验日期</th>
								<th data-options="field:'current_check_date',resizable:false,align:'center',sortable:'true',width:225">实际送检时间</th>
								<th data-options="field:'remark',resizable:false,align:'center',width:300">备注</th>
								</tr>
								</thead>
						 
					 </table>
					 <div id="tb2" style="height:28px;">
					    <div style="float:left;height:28px;">
					 		<span style="background:#FFCC33;width:77px;height:21px;display:inline-block;">&nbsp;&nbsp;<font color="white">30天内报警</font>&nbsp;&nbsp;</span>
							<span style="background:#FF3030;width:77px;height:21px;display:inline-block;">&nbsp;&nbsp;<font color="black">15天内报警</font>&nbsp;&nbsp;</span>
							<span style="background:#75D701;width:98px;height:21px;display:inline-block;">&nbsp;&nbsp;<font color="black">无下次检验日期</font></span>
						</div>
						<div style="float:left;height:28px;">
						 
							&nbsp;&nbsp;设备名称：<input id="query_dev_name" name="dev_name" class="input_width query" style="width:80px;float:none;">		
							&nbsp;&nbsp;设备型号：<input id="query_dev_model" name="dev_model" class="input_width query" style="width:80px;float:none;">		
							
							 						
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
							<a href="####" class="easyui-linkbutton" onclick="newSearch()"><i class="fa fa-filter fa-lg"></i>高级查询</a>							
						</div>
						<div style="float:right;height:28px;">
						
							<a href="####" class="easyui-linkbutton" onclick="downloadModel('dev_model','特种设备导入')"><i class="fa fa-download fa-lg"></i> 设备模板</a>
							<easyuiAuth:EasyUIButton functionId="devSpecial_data_add" className="fa fa-plus-circle fa-lg" event="toAddInPlanPage()" text="添加"></easyuiAuth:EasyUIButton>
							<a href="####" class="easyui-linkbutton" onclick="toEdit()"><i class="fa fa-pencil-square fa-lg"></i> 修改</a>	
							<easyuiAuth:EasyUIButton functionId="devSpecial_data_del" className="fa fa-trash-o fa-lg" event="toDelMixPlanPage()" text="删除"></easyuiAuth:EasyUIButton>
							<a href="####" class="easyui-linkbutton" onclick="excelDataAdd()"><i class="fa fa-upload fa-lg"></i> 导入</a>						
						    <a href="####" class="easyui-linkbutton" onclick="exportDatForEasyUItable('mixcoll_grid','特种设备',1,999999,'<%=contextPath%>')"><i class="fa fa-file-excel-o fa-lg"></i> 导出</a>
						    <easyuiAuth:EasyUIButton functionId="devSpecial_check_add" className="fa fa-file-word-o" event="checkInfo()" text="日常检查"></easyuiAuth:EasyUIButton>
						</div>						
					</div>
				</div>
			</div>
		</div>
		<!-- 页面下半部分 -->
		<div id="center" data-options="region:'center',title:'',split:true">	
			  <div id="tab" class="easyui-tabs" data-options="fit:true,plain:true">
			   <div title="基本信息" style="padding:10px;">
					<table id="detail" width="600" height="100"  style="overflow:hidden;"  class="tab_line_height">
					<tr>
						 <td class="inquire_item">设备名称：</td>
					     <td class="inquire_form" colspan="3">
					    	<input type="text" id="dev_name" class="input_width only_read datadetail" />
					     </td>
					     <td class="inquire_item">规格型号	：</td>
					     <td class="inquire_form" colspan="3">
					    	<input type="text" id="dev_model" class="input_width only_read datadetail" />
					     </td>
					     <td class="inquire_item">设备编码：</td>
					     <td class="inquire_form" colspan="3">
					    	<input type="text" id="dev_type" class="input_width only_read datadetail" />
					     </td>
					 </tr>
					 <tr>
					 	 <td class="inquire_item">出厂/管道编号：</td>
					     <td class="inquire_form" colspan="3">
					    	<input type="text" id="dev_num" class="input_width only_read datadetail" />
					     </td>
						 <td class="inquire_item">实物标识号：</td>
					     <td class="inquire_form" colspan="3">
					    	<input type="text" id="dev_sign" class="input_width only_read datadetail" />
					     </td>
					     <td class="inquire_item">ERP编号：</td>
					     <td class="inquire_form" colspan="3">
					    	<input type="text" id="dev_coding" class="input_width only_read datadetail" />
					     </td>
					 </tr>
					  <tr>
					     <td class="inquire_item">档案编号：</td>
					     <td class="inquire_form" colspan="3">
					    	<input type="text" id="record_num" class="input_width only_read datadetail" />
					     </td>
					     <td class="inquire_item">使用证编号：</td>
					     <td class="inquire_form" colspan="3">
					    	<input type="text" id="use_num" class="input_width only_read datadetail" />
					     </td>
					     <td class="inquire_item">单位内部编号：</td>
					     <td class="inquire_form" colspan="3">
					    	<input type="text" id="internal_num"   class="input_width only_read datadetail" />
					     </td>
					 </tr>
					 <tr>
					     <td class="inquire_item">主要用途：</td>
					     <td class="inquire_form" colspan="3">
					    	<input type="text" id="main_useinfo" class="input_width only_read datadetail" />
					     </td>
					     <td class="inquire_item">设备安装地点：</td>
					     <td class="inquire_form" colspan="3">
					    	<input type="text" id="installtion_place" class="input_width only_read datadetail" />
					     </td>
					     <td class="inquire_item">注册码：</td>
					     <td class="inquire_form" colspan="3">
					    	<input type="text" id="registration_code" class="input_width only_read datadetail" />
					     </td>
					 </tr>
					 <tr>
					     <td class="inquire_item">注册状态：</td>
					     <td class="inquire_form" colspan="3">
					    	<input type="text" id="zc_stat" class="input_width only_read datadetail" />
					     </td>
					     <td class="inquire_item">所属单位：</td>
					     <td class="inquire_form" colspan="3">
					    	<input type="text" id="org_name" class="input_width only_read datadetail" />
					     </td>
					     <td class="inquire_item">使用情况：</td>
					     <td class="inquire_form" colspan="3">
					    	<input type="text" id="using_stat" class="input_width only_read datadetail" />
					     </td>
					 </tr>
					  <tr>
					     <td class="inquire_item">技术状况：</td>
					     <td class="inquire_form" colspan="3">
					    	<input type="text" id="tech_stat" class="input_width only_read datadetail" />
					     </td>
					     <td class="inquire_item">国内/国外：</td>
					     <td class="inquire_form" colspan="3">
					    	<input type="text" id="ifcountry" class="input_width only_read datadetail" />
					     </td>
					     <td class="inquire_item">资产状态：</td>
					     <td class="inquire_form" colspan="3">
					    	<input type="text" id="account_stat" class="input_width only_read datadetail" />
					     </td>
					 </tr>
					 <tr>
					  <td class="inquire_item">投产日期：</td>
					     <td class="inquire_form" colspan="3">
					    	<input type="text" id="producting_date" class="input_width only_read datadetail" />
					     </td>
					  <td class="inquire_item">管理单位：</td>
					     <td class="inquire_form" colspan="3">
					    	<input type="text" id="org_name1" class="input_width only_read datadetail" />
					     </td>
					       <td class="inquire_item">日检人员：</td>
					     <td class="inquire_form" colspan="3">
					    	<input type="text" id="employee_name" class="input_width only_read datadetail" />
					     </td>
					       
					 </tr>
					 <tr>
					 <td class="inquire_item">备注：</td>
					     <td class="inquire_form" colspan="3">
					    	<input type="text" id="remark" class="input_width only_read datadetail" />
					     </td>
					     <td class="inquire_item">备注2：</td>
					     <td class="inquire_form" colspan="3">
					    	<input type="text" id="spare2" class="input_width only_read datadetail" />
					     </td>
					     <td class="inquire_item">备注1：</td>
					     <td class="inquire_form" colspan="3">
					    	<input type="text" id="spare1" class="input_width only_read datadetail" />
					     </td>
					     
					 </tr>
					 <tr>
					 <td class="inquire_item">备注3：</td>
					     <td class="inquire_form" colspan="3">
					    	<input type="text" id="spare3" class="input_width only_read datadetail" />
					     </td>
					 </tr>
				 </table>
             
                </div>
                <div title="日常检查表" style="padding:10px;">
                	 <table id="check_grid">
						<thead>
							<tr>
								<th data-options="field:'check_id',hidden:true,align:'center'" width="10">主键</th>
								<th data-options="field:'checkperson',align:'center',sortable:'true'" width="20">检查人</th>
								<th data-options="field:'actual_out_date',align:'center',sortable:'true'"   width="20">检查时间</th>
								<th data-options="field:'data_from',align:'center',sortable:'true'" width="20">数据来源</th>
								<th data-options="field:'self_num',align:'center',sortable:'true'" formatter="formatView" width="20" >操作</th>
								 
							</tr>
						</thead>
					 </table>
                </div>
                        <div title="审验信息" >
                	<table id="detail_grid">
						<thead>
							<tr>
								<th nowrap="false" data-options="field:'devspecial_id',checkbox:true,align:'center'" width="30">主键</th>
								<th nowrap="false" data-options="field:'check_unit',align:'center',sortable:'true'" width="20">检验单位</th>
								<th nowrap="false" data-options="field:'check_date',align:'center',sortable:'true'" width="10">检验日期</th>
							<!--	<th nowrap="false" data-options="field:'check_type',align:'center',sortable:'true'" width="10">检验类别</th> -->
								<th nowrap="false" data-options="field:'check_result',align:'center',sortable:'true'" width="10">检验结论</th>
							<!--	<th nowrap="false" data-options="field:'safe_level',align:'center',sortable:'true'" width="10">安全等级</th> -->
								<th nowrap="false" data-options="field:'main_question',align:'center',sortable:'true'" width="30">主要问题</th>
								<th nowrap="false" data-options="field:'next_date',align:'center',sortable:'true'" width="20">下次检验日期</th>
								<th nowrap="false" data-options="field:'file_id',align:'center',sortable:'true'" formatter="appFomtter" width="20">检验报告</th>
								
								
							</tr>
						</thead>
					</table>
					<div id="tb_detail" style="padding:5px;height:24px;">
						<div style="float:right;">
						<easyuiAuth:EasyUIButton functionId="devSpecial_sy_add" className="fa fa-plus-circle fa-lg" event="toAddCheckPage()" text="添加"></easyuiAuth:EasyUIButton>
						<easyuiAuth:EasyUIButton functionId="devSpecial_sy_upd" className="fa fa-plus-circle fa-lg" event="toupdateCheckPage()" text="修改"></easyuiAuth:EasyUIButton>
						<easyuiAuth:EasyUIButton functionId="devSpecial_sy_del" className="fa fa-trash-o fa-lg" event="toDelCheckPage()" text="删除"></easyuiAuth:EasyUIButton>
						</div>
					</div>
                </div>                       
				
				
				
				  <div title="维保记录" >
                	<table id="dtbywx_grid">
						<thead>
							<tr>
								<th nowrap="false" data-options="field:'dtbywx_id',checkbox:true,align:'center'" width="30">主键</th>
								<th nowrap="false" data-options="field:'bywx_person',align:'center',sortable:'true'" width="10">维保人员</th>
								<th nowrap="false" data-options="field:'bywx_company',align:'center',sortable:'true'" width="10">维保公司</th>
								<th nowrap="false" data-options="field:'bywx_result',align:'center',sortable:'true'" width="10">是否存在问题</th>
								<th nowrap="false" data-options="field:'bywx_question',align:'center',sortable:'true'" width="10">存在问题</th>
								<th nowrap="false" data-options="field:'bywx_date',align:'center',sortable:'true'" width="10">维保时间</th>
								<th nowrap="false" data-options="field:'file_id',align:'center',sortable:'true'" formatter="appFomtter" width="20">维保报告</th>
							</tr>
						</thead>
					</table>
					<div id="dt_detail" style="padding:5px;height:24px;">
						<div style="float:right;">
						<easyuiAuth:EasyUIButton functionId="devSpecial_wb_add" className="fa fa-plus-circle fa-lg" event="toAddbywxPage()" text="添加"></easyuiAuth:EasyUIButton>
						<easyuiAuth:EasyUIButton functionId="devSpecial_wb_upd" className="fa fa-plus-circle fa-lg" event="toupdatebywxPage()" text="修改"></easyuiAuth:EasyUIButton>
						<easyuiAuth:EasyUIButton functionId="devSpecial_wb_del" className="fa fa-trash-o fa-lg" event="toDelbywxPage()" text="删除"></easyuiAuth:EasyUIButton>
						</div>
					</div>
					
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
					//基本信息
					baseinfo(row.dev_acc_id);
				}else if(selectTabIndex==1){
					//日常检查
					loadMixCollInfo(row.dev_acc_id);
				}else if(selectTabIndex == 2){
					//审验信息
					loadMainDetial(row.dev_acc_id);
				}else if (selectTabIndex == 3){
				//电梯维保
				loadbywxDetial(row.dev_acc_id);
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
		pageList: [10, 20, 50, 100,200],
		rowStyler: function(index,row){
					if(row.coding_name!='停用'){//停用设备不报警
					if (row.days > -15){
						return 'background-color:#FF3030;color:#fff;font-weight:bold;';
					}else if (row.days > -30){
						return 'background-color:#FFCC33;color:#fff;font-weight:bold;';
					}else if (!row.next_date){//无下次检验日期
						return 'background-color:#75D701;color:#fff;font-weight:bold;';
					}
					}
				},
		onClickRow:function(index,data){
			currentId = data.dev_acc_id;
			if(selectTabIndex==0){
				baseinfo(currentId);
			}else if(selectTabIndex==1){
			 	loadMixCollInfo(currentId);
			}else if(selectTabIndex==2){			
			 	loadMainDetial(currentId);
			}else if (selectTabIndex == 3){
				//电梯维保
				loadbywxDetial(currentId);
			}
		},
		url:"${pageContext.request.contextPath}/dmsManager/safekeeping/queryKeepingConfInfoList.srq?JCDP_SRV_NAME=DevInfoConf&JCDP_OP_NAME=queryList",
		onLoadSuccess : function(data1) {
			for(var i = 0; i < data1.rows.length; i++){
                if(data1.rows[i].org_name!= undefined){
                    var orgname = data1.rows[i].org_name;
                     tipView('orgName-' + i,orgname,'top');    
                }
                 if(data1.rows[i].org_name1!= undefined){
                    var orgname1 = data1.rows[i].org_name1;
                     tipView('orgName1-' + i,orgname1,'top');    
                }
                if(data1.rows[i].installtion_place_desc!= undefined){
                    var installtion_place_desc = data1.rows[i].installtion_place;
                     tipView('Place-' + i,installtion_place_desc,'top');    
                }
                if(data1.rows[i].registration_code_desc!= undefined){
                    var registration_code_desc = data1.rows[i].registration_code;
                     tipView('Code-' + i,registration_code_desc,'top');    
                }
                          
            }
        }
	});
	});
	//检查表信息信息
	$("#check_grid").datagrid({ 
		method:'post',
		nowrap:false,
		rownumbers:true,//行号 
		title:"",
		border:false,
		striped:true,
		singleSelect:true,//是否单选 
		pagination:true,//分页控件 
		fit:true,//自动大小 
		fitColumns:true,
		url:"${pageContext.request.contextPath}/dmsManager/safekeeping/queryKeepingConfInfoList.srq?JCDP_SRV_NAME=DevInfoConf&JCDP_OP_NAME=queryCheckList"
	}); 

$("#detail_grid").datagrid({ 
		method:'post',
		rownumbers:true,
		toolbar:'#tb_detail',
		border:false,
		striped:true,
		singleSelect:true,//是否单选 ,
		pagination:true,
		fit:true,
		fitColumns:true
	});
	
	$("#dtbywx_grid").datagrid({ 
		method:'post',
		rownumbers:true,
		toolbar:'#dt_detail',
		border:false,
		striped:true,
		singleSelect:true,//是否单选 ,
		pagination:true,
		fit:true,
		fitColumns:true
	});
//修改
function toEdit(){
	var row = $('#mixcoll_grid').datagrid('getSelected');
 	if (row){
	popWindow("<%=contextPath%>/rm/dm/devSpecial/toAdd.jsp?addupflag=up&dev_acc_id="+row.dev_acc_id,"",'-添加/修改特种设备');
	}else{
		$.messager.alert('提示','请选择记录!','warning');
	}
}
//添加
function toAddInPlanPage(){
	//popWindow('${pageContext.request.contextPath}/rm/dm/devSpecial/add_dev.jsp?addupflag=add&thing_type=1','890:590',"-设备入库验收");
	//showDevTreePage();
	popWindow("<%=contextPath%>/rm/dm/devSpecial/toAdd.jsp?addupflag=add","",'-添加/修改特种设备');
}
 //选择单位设备
	function showDevTreePage(){
		var out_org_id = $("#out_sub_id").val();
		var returnValue = window.showModalDialog("<%=contextPath%>/rm/dm/devSpecial/add_devpage.jsp?out_org_id=<%=orgSubId%>","","dialogWidth=1200px;dialogHeight=480px");			
	 	if(typeof(returnValue)=="undefined"||returnValue==null||returnValue==''){return;}	
	 
		var retObj = jcdpCallService("DevInfoConf", "savedevSpecial","dev_acc_id="+returnValue);
		if(retObj.result=='0'){
			$("#mixcoll_grid").datagrid('reload');
		}
		$.messager.alert("提示",retObj.msg,"warning");
	}
	
//删除单据
function toDelMixPlanPage(){
	var row = $('#mixcoll_grid').datagrid('getSelected');
	 
	if (row){
		$.messager.confirm("操作提示", "您确定要执行操作吗？", function (data) {
	        if (data) {
	        	var retObj = jcdpCallService("DevInfoConf", "updatedevSpecial", "dev_acc_id="+row.dev_acc_id);
				 if(retObj.result=='0'){
					$("#mixcoll_grid").datagrid('reload');
					}	
				$.messager.alert("提示",retObj.msg,"warning");
			}
		});
	}else{
		$.messager.alert('提示','请选择记录!','warning');
	}
}
 
//加载附件
function loadDocList(mix_id){
	$("#attachement").attr("src",'${pageContext.request.contextPath}/doc/common/common_doc_list.jsp?relationId='+mix_id);
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
	//检查单填写
	function checkInfo(){
		var row = $('#mixcoll_grid').datagrid('getSelections');
	 
		if (row.length>0){
			var retObj = jcdpCallService("DevCommInfoSrv", "CheckInfoIsToday", "dev_acc_id="+row[0].dev_acc_id);
			if(retObj.result=='1'){
			$.messager.alert('提示','日常检查每天只能录入一条记录!','warning');
			return;
			}
			var dev_name=row[0].dev_name;
			dev_name = encodeURI(dev_name);
			dev_name = encodeURI(dev_name);
			var dev_num=row[0].dev_num;
			dev_num = encodeURIComponent (dev_num);
			dev_num = encodeURIComponent (dev_num);
			if(row[0].dev_type.indexOf('S1507')!=-1||row[0].dev_type.indexOf('S070102')!=-1||row[0].dev_type.indexOf('S080601')!=-1){
			popWindow("<%=contextPath%>/rm/dm/devSpecial/storeCheck.jsp?dev_num="+dev_num+"&dev_name="+dev_name+"&dev_type="+row[0].dev_type+"&dev_acc_id="+row[0].dev_acc_id,"1200:580",'-日常检查');  
			}else{
				$.messager.alert('提示','没有该类型检查表!','warning');
				return;
			}
		}else{
			$.messager.alert('提示','请选择记录!','warning');
		}
	}
	//检查单填写
	function checkInfonew(check_id,checkperson){
		var row = $('#mixcoll_grid').datagrid('getSelections');
		
		if (row.length>0){
			var dev_name=row[0].dev_name;
		 	var dev_num=row[0].dev_num;
		 	dev_num = encodeURIComponent (dev_num);
			dev_num = encodeURIComponent (dev_num);
			dev_name = encodeURI(dev_name);
			dev_name = encodeURI(dev_name);
			checkperson = encodeURI(checkperson);
			checkperson = encodeURI(checkperson);
			
			popWindow("<%=contextPath%>/rm/dm/devSpecial/storeCheck.jsp?dev_num="+dev_num+"&dev_name="+dev_name+"&checkperson="+checkperson+"&dev_type="+row[0].dev_type+"&dev_acc_id="+row[0].dev_acc_id+"&check_id="+check_id,"1200:580",'-验收单');  
		}else{
			$.messager.alert('提示','请选择记录!','warning');
		}
	}
	//删除检查单
	function toDelCheck(check_id){
		$.messager.confirm("操作提示", "您确定要执行操作吗？", function (data) {
	        if (data) {
	        	var retObj = jcdpCallService("DevCommInfoSrv", "delCheckInfo", "check_id="+check_id);
				 if(retObj.result=='0'){
					$("#check_grid").datagrid('reload');
					}	
				$.messager.alert("提示",retObj.msg,"warning");
			}
		});	
	} 
	//查看检查表详细信息
	function formatView(val,row){
		return "<button onclick=checkInfonew('"+row.check_id+"','"+row.checkperson+"')>查看</button>&nbsp;&nbsp;<button onclick=toDelCheck('"+row.check_id+"')>删除</button>";	 
	} 
	//查看检查表详细信息
	function formatView1(val,row){
				var checked=row.ischeck;
				 
				var types=row.types;
				var temp1 =checked.split(",");
				var temp2 =types.split(",");
				var typecount=0;
				for (var i=0;i<temp2.length;i++) {
					for (var j=0;j<temp1.length;j++) {
						if(temp2[i]==(temp1[j].split(":")[0])){
							typecount++;
						}
					}
				}
				if(typecount!=temp2.length){
					return val+"(未录入完毕)"	
				}else{
					return val+"(录入完毕)"	
				}
	 
	} 
	function loadMixCollInfo(dev_acc_id){
		//组织查询条件
		var params = {};
		params['dev_acc_id'] = dev_acc_id;
		queryParams = params;
		$("#check_grid").datagrid('reload',queryParams);
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
	//添加审验信息页面
	function toAddCheckPage(){
		var row = $('#mixcoll_grid').datagrid('getSelected');
		if(row){
		if(row.coding_name=='停用'){
		$.messager.alert('提示','停用设备无法添加审验信息!','warning');
		return ;
		}
		popWindow("<%=contextPath%>/rm/dm/devSpecial/toAddCheck.jsp?dev_acc_id="+row.dev_acc_id);
		}else{
			$.messager.alert('提示','请选择记录!','warning');
		}
	}
	//修改审验信息
	function toupdateCheckPage(){
	var row = $('#mixcoll_grid').datagrid('getSelected');
	var row1 = $('#detail_grid').datagrid('getSelected');
	if(row1){
	popWindow("<%=contextPath%>/rm/dm/devSpecial/toAddCheck.jsp?dev_acc_id="+row.dev_acc_id+"&devspecial_id="+row1.devspecial_id);
	}else{
		$.messager.alert('提示','请选择记录!','warning');
	}
	}
	//删除审验信息
	function toDelCheckPage(){
		var row1 = $('#detail_grid').datagrid('getSelected');
		if(row1){
		$.messager.confirm("操作提示", "您确定要执行操作吗？", function (data) {
		        if (data) {
		        	var retObj = jcdpCallService("DevCommInfoSrv", "delDevSCheckInfo", "devspecial_id="+row1.devspecial_id);
					 if(retObj.result=='0'){
						$("#detail_grid").datagrid('reload');
						}	
					$.messager.alert("提示",retObj.msg,"warning");
				}
			});
		}
	}
	//添加电梯维保信息页面
	function toAddbywxPage(){
		var row = $('#mixcoll_grid').datagrid('getSelected');
		if(row){
			popWindow("<%=contextPath%>/rm/dm/devSpecial/toAddBywx.jsp?dev_acc_id="+row.dev_acc_id);
		}else{
			$.messager.alert('提示','请选择记录!','warning');
		}
	}
	//修改电梯维保信息
	function toupdatebywxPage(){
		var row = $('#mixcoll_grid').datagrid('getSelected');
		var row1 = $('#dtbywx_grid').datagrid('getSelected');
		if(row1){
			popWindow("<%=contextPath%>/rm/dm/devSpecial/toAddBywx.jsp?dev_acc_id="+row.dev_acc_id+"&dtbywx_id="+row1.dtbywx_id);
		}else{
			$.messager.alert('提示','请选择记录!','warning');
		}
	}
	//删除电梯维保信息
	function toDelbywxPage(){
		var row1 = $('#dtbywx_grid').datagrid('getSelected');
		if(row1){
		$.messager.confirm("操作提示", "您确定要执行操作吗？", function (data) {
		        if (data) {
		        	var retObj = jcdpCallService("DevCommInfoSrv", "delDtBywx", "dtbywx_id="+row1.dtbywx_id);
					 if(retObj.result=='0'){
						$("#dtbywx_grid").datagrid('reload');
						}	
					$.messager.alert("提示",retObj.msg,"warning");
				}
			});
		}
	}
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
		        url: '${pageContext.request.contextPath}/rm/dm/ajaxRetMapBySrvAndMethod.srq?JCDP_SRV_NAME=DevInfoConf&JCDP_OP_NAME=getDevSpecialMainInfo',
		        data:{"devaccid":devaccid},
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
	//打开查询条件页面
    function newSearch(){
    	popWindow('<%=contextPath%>/rm/dm/devSpecial/devquery.jsp',"",'-高级查询');
    }
    //审验附件
    function appFomtter(val,row){
		return "<a href='<%=contextPath%>/doc/downloadDoc.srq?docId="+row.file_id+"'>"+row.file_name+"</a>";
	}
	//单位格式化
	function formatOrgName(value,row,index){
		return value.replace('中国石油集团东方地球物理勘探有限责任公司','').replace('东方地球物理公司','');
	}
	//格式化安装地址
	function formatPlace(value,row,index){
		if(value != "") {
		    return '<div id="Place-'+index+'" style="width:auto;">'+row.installtion_place_desc+'</div>';
		 }else{
		    return value;
		 }
	}
	//格式化注册码
	function formatCode(value,row,index){
		if(value != "") {
		    return '<div id="Code-'+index+'" style="width:auto;">'+row.registration_code_desc+'</div>';
		 }else{
		    return value;
		 }
	}
	
	//单位格式化
	function formatOrgName1(value,row,index){
		if(value != "") {
		    return '<div id="orgName1-'+index+'" style="width:auto;">'+row.org_abbreviation1+'</div>';
		 }else{
		    return value;
		 }
	}
	//导出方法
	function exportDatForEasyUItable(datagrid_name,filename,curPage, pageSize,contextPath){
	if(curPage==undefined) curPage=1;
	if(pageSize==undefined) pageSize=10;
	var submitStr = "page="+curPage+"&rows="+pageSize;
	var url = $("#"+datagrid_name).datagrid("options").url;
		url = url.substring(url.indexOf('?')+1);  
	var params = $("#"+datagrid_name).datagrid("options").queryParams;    // 获得参数
	for(var p in params){ 
    	submitStr=submitStr+"&"+p+"="+params[p];
    }
	
	var frozenColumns=$("#"+datagrid_name).datagrid("options").frozenColumns; //获得冻结列
    var columns = $("#"+datagrid_name).datagrid("options").columns;    //   获得列
	var columnExp="";
	var columnTitle="";
	$(frozenColumns).each(function (index) { 
		for (var i = 0; i < frozenColumns[index].length; ++i) { 
			var dc=frozenColumns[index][i].dc;//�Ƿ񵼳�
			if("undefined" == typeof dc||dc!=false){
		 	columnExp += frozenColumns[index][i].field + ",";
			columnTitle += frozenColumns[index][i].title+ ",";
			}
		}
	});
	$(columns).each(function (index) { 
		for (var i = 0; i < columns[index].length; ++i) { 
			var dc=columns[index][i].dc;//判断该列是否导出
			if("undefined" == typeof dc||dc!=false){
		 	columnExp += columns[index][i].field + ",";
			columnTitle += columns[index][i].title+ ",";
			}
		}
	});
 
	var querySql='';	
	var path = '';
		submitStr = encodeURI(submitStr);
		submitStr = encodeURI(submitStr);
		//if(cruConfig.submitStr!='')submitStr += "&"+cruConfig.submitStr;
		submitStr+="&"+url+"&JCDP_COLUMN_EXP="+columnExp+"&JCDP_COLUMN_TITLE="+columnTitle+"&JCDP_FILE_NAME="+filename;
		path = contextPath+"/common/excel/listToExcel.srq";
	var retObj = syncRequest("post", path, submitStr);
		filename = encodeURI(filename);
	    filename = encodeURI(filename);

	window.location=contextPath+"/common/download_temp.jsp?filename="+retObj.excelName+"&showname="+filename+".xls";
}
</script>
</html>
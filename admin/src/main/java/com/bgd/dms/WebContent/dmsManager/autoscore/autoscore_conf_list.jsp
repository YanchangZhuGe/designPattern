<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<%@include file="/common/include/quotesresource.jsp"%>
	<title>自动评分配置</title>
</head>

<body style="background:#cdddef">
	<div id="list_table">
		<div id="inq_tool_box">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
					<td background="<%=contextPath%>/images/list_15.png">
						<table width="100%" border="0" cellspacing="0" cellpadding="0">
							<tr>
								<td class="ali_cdn_name">配置表类型：</td>
				  				<td class="ali_cdn_input">
							   		<select id="q_conf_table_type"  name="conf_table_type" class="select_width">
										<option value="">请选择</option>
										<option value="0">评分表</option>
										<option value="1">考核表</option>
									</select>
							   	</td>
								<td class="ali_cdn_name">配置名称：</td>
				  				<td class="ali_cdn_input">
							   		<input id="q_conf_name" name="conf_name" type="text" class="input_width" />
							   	</td>
				  				<td class="ali_query">
				   					<span class="cx"><a href="####" onclick="simpleSearch()" title="JCDP_btn_query"></a></span>
								</td>
								<td class="ali_query">
							 		<span class="qc"><a href="####" onclick="clearQueryText()" title="JCDP_btn_clear"></a></span>
								</td>
								<td>&nbsp;</td>
								<auth:ListButton functionId="" css="zj" event="onclick='toAdd()'" title="JCDP_btn_add"></auth:ListButton>
								<auth:ListButton functionId="" css="xg" event="onclick='toEdit()'" title="JCDP_btn_edit"></auth:ListButton>
								<auth:ListButton functionId="" css="sc" event="onclick='toDelete()'" title="JCDP_btn_delete"></auth:ListButton>
					  		</tr>
						</table>
					</td>
				   	<td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
				</tr>
			</table>
		</div>
		<div id="table_box">
			<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">
				<tr>
					<td style="width:40px;" class="bt_info_odd" exp="<input type='radio' name='rdo_entity_id' value='{conf_id}' id='rdo_entity_id_{conf_id}'/>" >选择</td>
					<td class="bt_info_even" autoOrder="1">序号</td> 
					<td class="bt_info_odd" exp="{conf_name}">配置名称</td>
					<td class="bt_info_even" exp="{updator_name}">创建人</td>
					<td class="bt_info_odd" exp="{modify_date}">创建时间</td>
				</tr>
			</table>
		</div>
		<div id="fenye_box">
			<table width="100%" border="0" cellspacing="0" cellpadding="0" id="fenye_box_table">
				<tr>
					<td align="right">第1/1页，共0条记录</td>
					<td width="10">&nbsp;</td>
					<td width="30"><img src="<%=contextPath%>/images/fenye_01.png" width="20" height="20" /></td>
					<td width="30"><img src="<%=contextPath%>/images/fenye_02.png" width="20" height="20" /></td>
					<td width="30"><img src="<%=contextPath%>/images/fenye_03.png" width="20" height="20" /></td>
					<td width="30"><img src="<%=contextPath%>/images/fenye_04.png" width="20" height="20" /></td>
					<td width="50">到 
						<label>
							<input type="text" name="textfield" id="textfield" style="width:20px;" />
						</label>
					</td>
					<td align="left"><img src="<%=contextPath%>/images/fenye_go.png" width="22" height="22" /></td>
				</tr>
			</table>
		</div>
		<div class="lashen" id="line"></div>
		<div id="tag-container_3">
			<ul id="tags" class="tags">
				<li class="selectTag" id="tag3_0"><a href="####" onclick="getTab(0)">基本信息</a></li>
				<li id="tag3_1"><a href="####" onclick="getTab(1)">查询条件明细</a></li>
			</ul>
		</div>
		<div id="tab_box" class="tab_box">
			<div id="tab_box_content0" class="tab_box_content">
				<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
					<tr>
						<td class="inquire_item6">配置名称：</td>
					  	<td class="inquire_form6" >
					  		<input type="text" id="conf_name" name="conf_name" class="input_width main" readonly="readonly"/>
					  	</td>
					  	<td class="inquire_item6">创建人：</td>
					  	<td class="inquire_form6" >
					  		<input type="text" id="updator_name" name="updator_name"  class="input_width main" readonly="readonly"/>
					  	</td>
					  	<td class="inquire_item6">创建时间：</td>
					  	<td class="inquire_form6" >
					  		<input type="text" id="modify_date" name="modify_date"  class="input_width main" readonly="readonly"/>
					  	</td>
					</tr>
					<tr>
						<td class="inquire_item6">配置表名称：</td>
					  	<td class="inquire_form6" >
					  		<input type="text" id="conf_table_name" name="conf_table_name" class="input_width main" readonly="readonly"/>
					  	</td>
					  	<td class="inquire_item6">配置查询列：</td>
					  	<td class="inquire_form6" >
					  		<input type="text" id="conf_column_name" name="conf_column_name" class="input_width main" readonly="readonly"/>
					  	</td>
					  	<td class="inquire_item6"></td>
					  	<td class="inquire_form6"></td>
					</tr>		
					<tr>
						<td class="inquire_item6">配置视图内容：</td>
						<td class="inquire_form6" colspan="5">
							<textarea  id="conf_content" name="conf_content" class="textarea main" style="height:125px" readonly="readonly" >
							</textarea>
						</td>
					</tr>		    				    
				</table>	
			</div>
			<div id="tab_box_content1" class="tab_box_content">
				<iframe width="100%" height="100%" name="list" id="d_list" frameborder="0" src="" marginheight="0" marginwidth="0" >
				</iframe>	
			</div>
		</div>
	</div>
</body>
<script type="text/javascript">
	function frameSize(){
		setTabBoxHeight();
	}
	$(function(){
		frameSize();
		$(window).resize(function(){
	  		frameSize();
		});
	});
	
	$(document).ready(lashen);

	cruConfig.contextPath =  "<%=contextPath%>";
	cruConfig.cdtType = 'form';
	cruConfig.queryStr = "";
	cruConfig.queryService = "AutoScoreSrv";
	cruConfig.queryOp = "queryAutoScoreConfList";
	var path = "<%=contextPath%>";
	// 复杂查询
	function refreshData(conf_table_type,conf_name){
		var temp = "";
		if(typeof conf_table_type!="undefined" && conf_table_type!=""){
			temp += "&conf_table_type="+conf_table_type;
		}
		if(typeof conf_name!="undefined" && conf_name!=""){
			temp += "&conf_name="+conf_name;
		}
		cruConfig.submitStr = temp;	
		queryData(1);
	}

	refreshData("","");
		
	//简单查询
	function simpleSearch(){
	 	var q_conf_table_type = $("#q_conf_table_type").val(); 
	 	var q_conf_name = $("#q_conf_name").val(); 
		refreshData(q_conf_table_type,q_conf_name);
	}
	//清空查询条件
	function clearQueryText(){
		$("#q_conf_table_type").val("");
		$("#q_conf_name").val("");
		refreshData("","");
	}
	
	//双击事件
	function dbclickRow(ids){	
		//cruConfig.submitStr = "per_id="+ids;	
		//queryData(1);
	}
	
	//点击tab页
	var selectedTagIndex = 0;
	var showTabBox = document.getElementById("tab_box_content0");
	var selected_id = "";//加载数据时，选中记录id
	var tab_index =0;//tab页索引
	//点击tab,显示具体tab
	function getTab(index){
		tab_index=index;
		getTab3(index);
		$(".tab_box_content").hide();
		$("#tab_box_content"+index).show();
		loadDataDetail(selected_id);
	}
	//加载单条记录的详细信息
	function loadDataDetail(ids){
		selected_id=ids;
		if(0==tab_index){
			var retObj = jcdpCallService("AutoScoreSrv", "getAutoScoreConfInfo", "conf_id="+ids);
			if(typeof retObj.data!="undefined"){
				var data = retObj.data;
				$(".main").each(function(){
					var temp = this.id;
					$("#"+temp).val(data[temp] != undefined ? data[temp]:"");
				});
			}
		}
		if(1==tab_index){
			$("#d_list").attr("src","<%=contextPath%>/dmsManager/autoscore/autoscore_conf_detail_list.jsp?confId="+ids);
		}
	}
	//新增
	function toAdd(){ 
		popWindow('<%=contextPath %>/dmsManager/autoscore/autoscore_conf_edit.jsp?flag=add','800:480','-新增自动评分配置项');
	}
	//修改
	function toEdit(){ 
	    ids = getSelIds('rdo_entity_id');
	    if(ids==''){ 
	    	$.messager.alert("提示","请选择记录!","warning");
	     	return;
	    }
		popWindow('<%=contextPath %>/dmsManager/autoscore/autoscore_conf_edit.jsp?flag=update&conf_id='+ids,'800:480','-修改自动评分配置项');
	}
	
	//删除
	function toDelete(){
	    ids = getSelIds('rdo_entity_id');
	    if(ids==''){ 
	    	$.messager.alert("提示","请选择记录!","warning");
	     	return;
	    }
	    $.messager.confirm("操作提示", "您确定要执行操作吗？", function (data) {
	        if (data) {
	        	var retObj = jcdpCallService("AutoScoreSrv", "deleteAutoScoreInfo", "conf_id="+ids);
				if(typeof retObj.operationFlag!="undefined"){
					var dOperationFlag = retObj.operationFlag;
					if('' != dOperationFlag){
						if("failed"==dOperationFlag){
							$.messager.alert("提示","删除失败!","error");
							return;
						}	
						if("success" == dOperationFlag){
							$.messager.alert("提示","删除成功!","info");
							queryData(cruConfig.currentPage);
							$(".main").each(function(){
								var temp = this.id;
								$("#"+temp).val("");
							});
						}
					}
				}
			}
		});
	}
</script>
</html>


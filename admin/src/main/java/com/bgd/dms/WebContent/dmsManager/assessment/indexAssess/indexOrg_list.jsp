<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="auth" uri="auth"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="java.util.*,com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%
	String contextPath = request.getContextPath();
	String org_id=request.getParameter("org_id");
	if(null==org_id){
		org_id="";
	}
	String subOrg_id=request.getParameter("subOrg_id");
	if(null==subOrg_id){
		subOrg_id="";
	}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
	<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
	<link href="<%=contextPath%>/css/calendar-blue.css" rel="stylesheet" type="text/css" />
	<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
	<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
	<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
	<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
	<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
	<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
	<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
	<title>机构指标列表信息</title>
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
								<td class="ali_cdn_name">指标名称：</td>
					  			<td class="ali_cdn_input">
					   				<input id="q_index_name" name="index_name" type="text" class="input_width" />
					  			</td>
				  				<td class="ali_query">
				   					<span class="cx"><a href="#" onclick="simpleSearch()" title="JCDP_btn_query"></a></span>
								</td>
								<td class="ali_query">
							 		<span class="qc"><a href="#" onclick="clearQueryText()" title="JCDP_btn_clear"></a></span>
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
					<td style="width:40px;" class="bt_info_odd" exp="<input type='radio' name='rdo_entity_id' value='{unit_id}' id='rdo_entity_id_{unit_id}'/>" >选择</td>
					<td class="bt_info_even" autoOrder="1">序号</td> 
					<td class="bt_info_odd" exp="{index_name}">指标名称</td>
					<td class="bt_info_even" exp="{org_name}">单位</td>
					<td class="bt_info_odd" exp="{updator_name}">创建人</td>
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
				<li class="selectTag" id="tag3_0"><a href="#" onclick="getTab(0)">明细信息</a></li>
			</ul>
		</div>
		<div id="tab_box" class="tab_box">
			<div id="tab_box_content0" class="tab_box_content">
				<fieldset style="margin-left:2px"><legend>指标基本信息</legend>
					<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
						<tr>
							<td class="inquire_item6">指标名称：</td>
						  	<td class="inquire_form6" >
						  		<input type="text" id="index_name" name="index_name" class="input_width main" readonly="readonly"/>
						  	</td>
						  	<td class="inquire_item6">单位：</td>
						  	<td class="inquire_form6" >
						  		<input type="text" id="org_name" name="org_name"  class="input_width main" readonly="readonly"/>
						  	</td>
						</tr>			    				    
					</table>	
				</fieldset>
				<fieldset style="margin-left:2px;overflow-y:auto;" >
					<legend>指标项信息</legend>
					<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
						<tr>
							<td class="inquire_form6" colspan="4">
								<textarea id="item_names" name="item_names" rows="4" cols="80" class="main" readonly></textarea>
							</td>
						</tr>		  	
  					</table>
				</fieldset>	
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
	cruConfig.queryService = "IndexAssessSrv";
	cruConfig.queryOp = "queryIndexOrgInfoList";
	var path = "<%=contextPath%>";
	var org_id = "<%=org_id%>";
	var subOrg_id = "<%=subOrg_id%>";
	// 复杂查询
	function refreshData(index_name,org_id,subOrg_id){
		var temp = "";
		if(typeof index_name!="undefined" && index_name!=""){
			temp += "&index_name="+index_name;
		}
		if(typeof org_id!="undefined" && org_id!=""){
			temp += "&org_id="+org_id;
		}
		if(typeof subOrg_id!="undefined" && subOrg_id!=""){
			temp += "&subOrg_id="+subOrg_id;
		}
		cruConfig.submitStr = temp;	
		queryData(1);
	}

	refreshData("",org_id,subOrg_id);
	
	
	//简单查询
	function simpleSearch(){
	 	var q_index_name = $("#q_index_name").val(); 
		refreshData(q_index_name,org_id,subOrg_id);
	}
	//清空查询条件
	function clearQueryText(){
		document.getElementById("q_index_name").value = "";
		refreshData("",org_id,subOrg_id);
	}
	
	//双击事件
	function dbclickRow(ids){	
	}
	
	//新增
	function toAdd(){ 
		if(''==org_id || 'C105'==org_id){
			alert("请选择单位");
		}else{
			popWindow('<%=contextPath %>/dmsManager/assessment/indexAssess/indexOrg_edit.jsp?flag=add&org_id='+org_id+'&subOrg_id='+subOrg_id,'800:680');
		}

	}
	//修改
	function toEdit(){ 
	    ids = getSelIds('rdo_entity_id');
	    if(ids==''){ 
	    	alert("请选择记录!");
	     	return;
	    }
		popWindow('<%=contextPath %>/dmsManager/assessment/indexAssess/indexOrg_edit.jsp?flag=update&unit_id='+ids,'800:680');
	}
	
	//删除
	function toDelete(){
	    ids = getSelIds('rdo_entity_id');
	    if(ids==''){ 
	    	alert("请选择记录!");
	     	return;
	    }
		if(confirm('确定要删除吗?')){  
			var retObj = jcdpCallService("IndexAssessSrv", "deleteIndexOrgInfo", "unit_id="+ids);
			if(typeof retObj.operationFlag!="undefined"){
				var dOperationFlag=retObj.operationFlag;
				if(''!=dOperationFlag){
					if("failed"==dOperationFlag){
						alert("删除失败！");
						return;
					}	
					if("success"==dOperationFlag){
						alert("删除成功！");
						queryData(cruConfig.currentPage);
						$(".main").each(function(){
							var temp = this.id;
							$("#"+temp).val("");
						});
						queryData(cruConfig.currentPage);
					}
				}
			}
		}
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
			var retObj = jcdpCallService("IndexAssessSrv", "getIndexOrgInfo", "unit_id="+ids);
			if(typeof retObj.data!="undefined"){
				var data = retObj.data;
				$(".main").each(function(){
					var temp = this.id;
					$("#"+temp).val(data[temp] != undefined ? data[temp]:"");
				});
			}
		}
	}
</script>
</html>


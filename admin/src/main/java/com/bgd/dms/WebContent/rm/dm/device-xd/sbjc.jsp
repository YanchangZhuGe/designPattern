<%@ page contentType="text/html;charset=UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%@taglib uri="wf" prefix="wf"%>
<%
	String contextPath = request.getContextPath();    
	UserToken user = OMSMVCUtil.getUserToken(request);
	String projectType = user.getProjectType();	
	String taskId = request.getParameter("taskId");	
	String projectInfoNo = user.getProjectInfoNo();	
    String code = request.getParameter("code");   
	String userOrgId = user.getSubOrgIDofAffordOrg();
	//设备检查类型	
	String inspection_type = request.getParameter("inspection_type");
	if(null==inspection_type){
		inspection_type="";
	}
	
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" /> 
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/Calendar1.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open1.js"></script>
<title>设备检查列表</title>
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
					  			<td class="ali_cdn_name">设备名称：</td>
					  			<td class="ali_cdn_input">
					   				<input id="q_dev_name" name="dev_name" type="text" class="input_width" />
					  			</td>
				   				<td class="ali_cdn_name">规格型号：</td>
				  				<td class="ali_cdn_input">
							   		<input id="q_dev_model" name="dev_model" type="text" class="input_width"/>
							  	</td>
							  	<td class="ali_cdn_name">自编号：</td>
				  				<td class="ali_cdn_input">
							   		<input id="q_self_num" name="self_num" type="text" class="input_width"/>
							  	</td>
							  	<td class="ali_cdn_name">牌照号：</td>
				  				<td class="ali_cdn_input">
							   		<input id="q_license_num" name="license_num" type="text" class="input_width"/>
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
								<auth:ListButton functionId="" css="xz" event="onclick='toDownload()'" title="JCDP_btn_download"></auth:ListButton>
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
					<td style="width:40px;" class="bt_info_even" exp="<input  type='checkbox' name='rdo_entity_id' value='{inspection_id}_{ucm_id}' id='rdo_entity_id_{inspection_id}'/>" >选择</td>
					<td class="bt_info_odd" autoOrder="1">序号</td> 
					<td class="bt_info_even" exp="{dev_name}">设备名称</td>
					<td class="bt_info_odd" exp="{dev_model}">规格型号</td>
					<td class="bt_info_even" exp="{self_num}">自编号</td>
					<td class="bt_info_odd" exp="{license_num}">牌照号</td>
					<td class="bt_info_even" exp="{owning_org_name}">所在单位</td>
					<td class="bt_info_odd" exp="{project_name}">项目名称</td>
					<td class="bt_info_even" exp="{inspection_type_name}">检查类型</td>
					<td class="bt_info_odd" exp="{inspector}">检查人</td>
					<td class="bt_info_even" exp="{inspection_date}">检查日期</td>
					<td class="bt_info_odd" exp="{charge_person}">责任人</td>
					<td class="bt_info_even" exp="{file_name}">附件</td>
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
				<li class="selectTag" id="tag3_0"><a href="#" onclick="getTab(0)">基本信息</a></li>
			</ul>
		</div>
		<div id="tab_box" class="tab_box">
			<div id="tab_box_content0" class="tab_box_content">
				<table width="100%" border="0" cellspacing="0" cellpadding="0" id="commonInfoTable" class="tab_line_height">
					<tr>
					    <td class="inquire_item6">项目名称：</td>
					    <td class="inquire_form6" colspan="5"><input type="text"  id="project_name" name="project_name"  class="input_width" readonly="readonly"/></td>
					 </tr>
					 <tr>
					    <td class="inquire_item6">检查类型：</td>
						<td class="inquire_form6"><input type="text" id="inspection_type_name" name="inspection_type_name" class="input_width" readonly="readonly"/></td>
						<td class="inquire_item6">设备名称：</td>
						<td class="inquire_form6"><input type="text" id="dev_name" name="dev_name" class="input_width" readonly="readonly"/></td>
						<td class="inquire_item6">规格型号：</td>
					    <td class="inquire_form6"><input type="text"  id="dev_model" name="dev_model"  class="input_width" readonly="readonly"/></td>
					 </tr>
					 <tr>
					    <td class="inquire_item6">自编号：</td>
						<td class="inquire_form6"><input type="text" id="self_num" name="self_num" class="input_width" readonly="readonly"/></td>
						<td class="inquire_item6">牌照号：</td>
						<td class="inquire_form6"><input type="text" id="license_num" name="license_num" class="input_width" readonly="readonly"/></td>
						<td class="inquire_item6">检查人：</td>
					    <td class="inquire_form6"><input type="text"  id="inspector" name="inspector"  class="input_width" readonly="readonly"/></td>
					 </tr>
					 <tr>
					    <td class="inquire_item6">检查日期：</td>
						<td class="inquire_form6"><input type="text" id="inspection_date" name="inspection_date" class="input_width" readonly="readonly"/></td>
						<td class="inquire_item6">整改期限：</td>
						<td class="inquire_form6"><input type="text" id="rectification_period" name="rectification_period" class="input_width" readonly="readonly"/></td>
						<td class="inquire_item6">责任人：</td>
					    <td class="inquire_form6"><input type="text"  id="charge_person" name="charge_person"  class="input_width" readonly="readonly"/></td>
					 </tr>
					 <tr>
					    <td class="inquire_item6">是否合格：</td>
						<td class="inquire_form6"><input type="text" id="spare1_name" name="spare1_name" class="input_width" readonly="readonly"/></td>
						<td class="inquire_item6">整改时间：</td>
						<td class="inquire_form6"><input type="text" id="rectify_date" name="rectify_date" class="input_width" readonly="readonly"/></td>
						<td class="inquire_item6">整改人：</td>
						<td class="inquire_form6"><input type="text" id="rectify_person" name="rectify_person" class="input_width" readonly="readonly"/></td>
					</tr>	
					<tr>
						<td class="inquire_item6">检查内容：</td>
						<td class="inquire_form6" colspan="5"><textarea  id="inspection_content" name="inspection_content" readonly="readonly" class="textarea" style="height:40px"></textarea></td>
					</tr>	
					<tr>
						<td class="inquire_item6">整改问题：</td>
						<td class="inquire_form6" colspan="5"><textarea  id="inspection_result" name="inspection_result" readonly="readonly" class="textarea" style="height:40px"></textarea></td>
					</tr>
					<tr>
						<td class="inquire_item6">整改结果：</td>
						<td class="inquire_form6" colspan="5"><textarea  id="rectify_content" name="rectify_content" readonly="readonly" class="textarea" style="height:40px"></textarea></td>
					</tr>			    
				</table>
			</div>
		</div>
	</div>
</body>
<script type="text/javascript">
	function frameSize(){
		setTabBoxHeight();
	}
	frameSize();
	
	
	$(function(){
		$(window).resize(function(){
	  		frameSize();
		});
	});
	
	$(document).ready(lashen);

	cruConfig.contextPath =  "<%=contextPath%>";
	cruConfig.cdtType = 'form';
	cruConfig.queryStr = "";
	cruConfig.queryService = "DevInsSrv";
	cruConfig.queryOp = "queryDevInsList";
	var projectInfoNo = "<%=projectInfoNo%>";
	var inspection_type= "<%=inspection_type%>";
	
	// 复杂查询
	function refreshData(dev_name,dev_model,self_num,license_num){
		var temp = "project_info_no="+projectInfoNo+"&inspection_type="+inspection_type;
		if(typeof dev_name!="undefined" && dev_name!=""){
			temp += "&dev_name="+dev_name;
		}
		if(typeof dev_model!="undefined" && dev_model!=""){
			temp += "&dev_model="+dev_model;
		}
		if(typeof self_num!="undefined" && self_num!=""){
			temp += "&self_num="+self_num;
		}
		if(typeof license_num!="undefined" && license_num!=""){
			temp += "&license_num="+license_num;
		}
		cruConfig.submitStr = temp;	
		queryData(1);
	}

	refreshData("","","","");
	
	//简单查询
	function simpleSearch(){
	 	var q_dev_name = $("#q_dev_name").val(); 
	    var q_dev_model = $("#q_dev_model").val(); 
	    var q_self_num = $("#q_self_num").val(); 
	    var q_license_num = $("#q_license_num").val(); 
		refreshData(q_dev_name,q_dev_model,q_self_num,q_license_num);
	}
	//清空查询条件
	function clearQueryText(){
		document.getElementById("q_dev_name").value = "";
		document.getElementById("q_dev_model").value = "";
		document.getElementById("q_self_num").value = "";
		document.getElementById("q_license_num").value = "";
		refreshData("","","","");
	}
	
	//双击事件
	function dbclickRow(ids){	
		//cruConfig.submitStr = "per_id="+ids;	
		//queryData(1);
	}
	
	//新增
	function toAdd(){
		popWindow('<%=contextPath %>/rm/dm/device-xd/sbjc_edit.jsp?flag=add&project_info_no='+projectInfoNo+"&inspection_type="+inspection_type);		
	}

	//修改
	function toEdit(){ 
	    ids = getSelIds('rdo_entity_id');
	    if(ids==''){ alert("请选择记录!");
	     	return;
	    }	
	    if(ids.split(",").length > 1){
	    	alert("只能选中一条记录");
	    	return;
	    }
		popWindow('<%=contextPath%>/rm/dm/device-xd/sbjc_edit.jsp?flag=edit&id='+ids.split("_")[0]+"&inspection_type="+inspection_type);
	}
	
	//删除
	function toDelete(){
	    ids = getSelIds('rdo_entity_id');
	    if(ids==''){ 
	    	alert("请选择记录!");
	     	return;
	    }	
		if(confirm('确定要删除吗?')){  
			var retObj = jcdpCallService("DevInsSrv", "deleteDevIns", "ids="+ids);
			queryData(cruConfig.currentPage);
			clearCommonInfo();
		}
	}
	 //下载文档
	 function toDownload(){
		 ids = getSelIds('rdo_entity_id');
		    if(ids==''){ 
		    	alert("请选择记录!");
		     	return;
		    }	
		    if(ids.split(",").length > 1){
		    	alert("只能选中一条记录");
		    	return;
		    }
		    var ucm_id="";
		    ucm_id=ids.split("_")[1];
		    if(ucm_id != ""){
		    	window.location = "<%=contextPath%>/doc/downloadDocByUcmId.srq?docId="+ucm_id;
		    }else{
		    	alert("该条记录没有文档");
		    	return;
		    }
		    
		}
	//清空表格
	function clearCommonInfo(){
		var qTable = getObj('commonInfoTable');
		for (var i=0;i<qTable.all.length; i++) {
			var obj = qTable.all[i];
			if(obj.name==undefined || obj.name=='') continue;
			
			if (obj.tagName == "INPUT") {
				if(obj.type == "text") 	obj.value = "";		
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
			var retObj = jcdpCallService("DevInsSrv", "getDevInsInfo", "id="+ids.split("_")[0]);
			var data = retObj.data;
			$(".input_width , .textarea").each(function(){
				var temp = this.id;
				$("#"+this.id).val(data[temp] != undefined ? data[temp]:"");
			});
		}
	}
</script>
</html>


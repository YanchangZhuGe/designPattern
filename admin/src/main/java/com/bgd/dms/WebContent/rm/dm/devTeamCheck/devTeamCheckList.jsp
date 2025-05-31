<%@ page contentType="text/html;charset=UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%@taglib uri="wf" prefix="wf"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String projectInfoNo = user.getProjectInfoNo();
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
	<script type="text/javascript" src="<%=contextPath%>/js/dialog_open1.js"></script>
	<title>班组检查</title>
</head>

<body style="background: #cdddef">
	<div id="list_table">
		<div id="inq_tool_box">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
					<td background="<%=contextPath%>/images/list_15.png">
						<table width="100%" border="0" cellspacing="0" cellpadding="0">
							<tr>
								<td class="ali_cdn_name">班组名称</td>
								<td class="ali_cdn_input" style="width: 100px">
									<select id="s_team_id" name="team_id" class="input_select">
											<option value=''>请选择</option>
									</select>
								</td>
								<td class="ali_cdn_name">数据来源</td>
								<td class="ali_cdn_input" style="width: 100px">
									<select id="s_data_source" name="data_source" class="input_select">
										<option value=''>请选择</option>
										<option value='0'>平台录入</option>
										<option value='1'>手持机同步</option>
									</select>
								</td>
								<td class="ali_query"><span class="cx"><a href="#" onclick="simpleSearch()" title="JCDP_btn_query"></a></span></td>
								<td class="ali_query"><span class="qc"><a href="#" onclick="clearQueryText()" title="JCDP_btn_clear"></a></span></td>
								<td><span style="font-size: 16px; color: red;">&nbsp;&nbsp;说明：双击记录进行单机检查操作（只能操作平台录入数据）</span></td>
								<auth:ListButton functionId="" css="zj" event="onclick='toAdd()'" title="JCDP_btn_add"></auth:ListButton>
								<auth:ListButton functionId="" css="xg" event="onclick='toEdit()'" title="JCDP_btn_edit"></auth:ListButton>
								<auth:ListButton functionId="" css="sc" event="onclick='toDelete()'" title="JCDP_btn_delete"></auth:ListButton>
								<auth:ListButton functionId="" css="dc" event="onclick='exportData()'" title="JCDP_btn_export"></auth:ListButton>
							</tr>
						</table>
					</td>
					<td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
				</tr>
			</table>
		</div>
		<div id="table_box">
			<table style="width: 98.5%" border="0" cellspacing="0"
				cellpadding="0" class="tab_info" id="queryRetTable">
				<tr>
					<td class="bt_info_even" exp="<input type='checkbox' name='rdo_entity_id' value='{inspection_team_id}' id='rdo_entity_id_{inspection_team_id}' />" >选择</td>
					<td class="bt_info_odd" exp="{team_name}">班组名称</td>
					<td class="bt_info_even" exp="{check_date}">检查日期</td>
					<td class="bt_info_odd" exp="{check_person}">检查人员</td>
					<td class="bt_info_even" exp="{data_source_name}">数据来源</td>
				</tr>
			</table>
		</div>
		<div id="fenye_box" style="display: block">
			<table width="100%" border="0" cellspacing="0" cellpadding="0"
				id="fenye_box_table">
				<tr>
					<td align="right">第1/1页，共0条记录</td>
					<td width="10">&nbsp;</td>
					<td width="30"><img src="<%=contextPath%>/images/fenye_01.png" width="20" height="20" /></td>
					<td width="30"><img src="<%=contextPath%>/images/fenye_02.png" width="20" height="20" /></td>
					<td width="30"><img src="<%=contextPath%>/images/fenye_03.png" width="20" height="20" /></td>
					<td width="30"><img src="<%=contextPath%>/images/fenye_04.png" width="20" height="20" /></td>
					<td width="50">到 <label><input type="text" name="textfield" id="textfield" style="width: 20px;" /></label></td>
					<td align="left"><img src="<%=contextPath%>/images/fenye_go.png" width="22" height="22" /></td>
				</tr>
			</table>
		</div>
		<div class="lashen" id="line"></div>
		<div id="tag-container_3">
			<ul id="tags" class="tags">
				<li class="selectTag" id="tag3_0"><a href="#"
					onclick="getTab3(0)">检查内容</a></li>
				<li id="tag3_1"><a href="#" onclick="getTab3(1)">整改内容</a></li>
				<li id="tag3_2"><a href="#" onclick="getTab3(2)">检查设备</a></li>
			</ul>
		</div>
		<div id="tab_box" class="tab_box">
			<div id="tab_box_content0" name="tab_box_content0"
				class="tab_box_content">
				<table id="devMap" width="100%" border="0" cellspacing="0"
					cellpadding="0" class="tab_info" style="margin-top: 2px;">
					<tr>
						<td class="inquire_item6">班组制度执行情况：</td>
						<td class="inquire_form6">
							<input type="radio" name="system_situation" value="1">良好</input>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							<input type="radio" name="system_situation" value="2">一般</input>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							<input type="radio" name="system_situation" value="3">差</input>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
						</td>
					</tr>
					<tr>
						<td class="inquire_item6">班组设备日常检查及保养情况：</td>
						<td class="inquire_form6">
							<input type="radio" name="check_situation" value="1">良好</input>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							<input type="radio" name="check_situation" value="2">一般</input>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							<input type="radio" name="check_situation" value="3">差</input>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
						</td>
					</tr>
					<tr>
						<td class="inquire_item6">班组设备使用情况：</td>
						<td class="inquire_form6">
							<input type="radio" name="device_situation" value="1">良好</input>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							<input type="radio" name="device_situation" value="2">一般</input>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							<input type="radio" name="device_situation" value="3">差</input>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
						</td>
					</tr>
					<tr>
						<td class="inquire_item6">班组HSE设施完好情况：</td>
						<td class="inquire_form6">
							<input type="radio" name="hse_situation" value="1">良好</input>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							<input type="radio" name="hse_situation" value="2">一般</input>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							<input type="radio" name="hse_situation" value="3">差</input>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
						</td>
					</tr>
				</table>
			</div>
			<div id="tab_box_content1" name="tab_box_content1"
				class="tab_box_content" style="display: none;">
				<table id="devMap" width="100%" border="0" cellspacing="0"
					cellpadding="0" class="tab_info" style="margin-top: 2px;">
					<tr>
						<td class="inquire_item6">整改事项：</td>
						<td class="inquire_form6">
							<input id="modifi_project" name="modifi_project" class="input_width" type="text" />
						</td>
						<td class="inquire_item6">整改日期：</td>
						<td class="inquire_form6">
							<input id="modifi_time" name="modifi_time" class="input_width" type="text" />
						</td>
						<td class="inquire_item6">整改人员：</td>
						<td class="inquire_form6">
							<input id="modifi_person" name="modifi_person" class="input_width" type="text" />
						</td>
					</tr>
					<tr>
						<td class="inquire_item6">备注</td>
						<td class="inquire_form6" colspan="5">
							<textarea rows="" cols="" id="memo" name="memo" class="textarea"></textarea>
						</td>
					</tr>

				</table>
			</div>
			<!--设备检查-->
			<div id="tab_box_content2" name="tab_box_content2"
				class="tab_box_content" style="display: none;">
				<div style="overflow: auto">
					<table width="97%" border="0" cellspacing="0" cellpadding="0"
						class="tab_line_height">
						<tr align="right">
							<td class="ali_cdn_name"></td>
							<td class="ali_cdn_input"></td>
							<td class="ali_cdn_name"></td>
							<td class="ali_cdn_input"></td>
							<td>&nbsp;</td>
						</tr>
					</table>
				</div>
				<table id="jcMap" width="250%" border="0" cellspacing="0"
					cellpadding="0" class="tab_info" style="margin-top: 2px;">
					<tr>
						<td class="bt_info_odd">序号</td>
						<td class="bt_info_even">设备名称</td>
						<td class="bt_info_odd">规格型号</td>
						<td class="bt_info_even">自编号</td>
						<td class="bt_info_odd">牌照号</td>
						<td class="bt_info_even">文件</td>
					</tr>
					<tbody id="assign_body"></tbody>
				</table>
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
		var sretObj = jcdpCallService("DevTeamCheckSrv", "getTeamInfo", "");
		if(typeof sretObj.datas!="undefined"){
			var sdatas = sretObj.datas;
			for(var i=0;i<sdatas.length;i++){
				var sdata=sdatas[i];
				$("#s_team_id").append("<option value='"+sdata.id+"'>"+sdata.name+"</option>");
			}
		}
	});

	$(document).ready(lashen);

	cruConfig.contextPath =  "<%=contextPath%>";
	cruConfig.cdtType = 'form';
	cruConfig.queryStr = "";
	cruConfig.queryService = "DevTeamCheckSrv";
	cruConfig.queryOp = "queryDevTeamCheckList";
	var path = "<%=contextPath%>";
	// 复杂查询
	function refreshData(s_team_id,s_data_source){
		var temp = "";
		if(typeof s_team_id!="undefined" && s_team_id!=""){
			temp += "&teamId="+s_team_id;
		}
		if(typeof s_data_source!="undefined" && s_data_source!=""){
			temp += "&dataSource="+s_data_source;
		}
		cruConfig.submitStr = temp;	
		queryData(1);
	}
	
	refreshData("","");
	
	
	//简单查询
	function simpleSearch(){
	 	var s_team_id = $("#s_team_id").val(); 
	 	var s_data_source = $("#s_data_source").val(); 
		refreshData(s_team_id,s_data_source);
	}
	//清空查询条件
	function clearQueryText(){
		document.getElementById("s_team_id").value = "";
		document.getElementById("s_data_source").value = "";
		refreshData("","");
	}
	//双击事件
	function dbclickRow(ids){	
		var dbretObj= jcdpCallService("DevTeamCheckSrv", "getDevTeamCheckInfo", "id="+ids);
		if(typeof dbretObj.data!="undefined"){
			var dbdata = dbretObj.data;
			if("0"!=dbdata.data_source){
				alert("数据来源为手持机，不能修改!");
				return;
			}
			window.location.href='<%=contextPath %>/rm/dm/devTeamCheck/singleDevCheckList.jsp?inspectionTeamId='+ids+'&teamId='+dbdata.team_id;	
		}
	}
	
	var selectedTagIndex = 0;
	var showTabBox = document.getElementById("tab_box_content0");
	
    function loadDataDetail(shuaId){
		
    	var retObj;
    	$("#queryRetTable :checked").removeAttr("checked");
    	$("#rdo_entity_id_"+shuaId).attr("checked","checked");
		if(shuaId!=null){
			var querySql="select t.inspection_team_id,t.modifi_project,t.modifi_time,t.modifi_person,t.memo,t.system_situation,t.check_situation,t.device_situation,t.hse_situation from  BGP_DEVICE_INSPECTION_TEAM t  where t.inspection_team_id= '"+shuaId+"'" ;
			var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql);
			retObj = queryRet.datas;
		}else{
			var ids = getSelIds('rdo_entity_id');
			
		    if(ids==''){ 
			    alert("请先选中一条记录!");
	     		return;
		    }
		    var querySql="select t.inspection_team_id,t.modifi_project,t.modifi_time,t.modifi_person,t.memo,t.system_situation,t.check_situation,t.device_situation,t.hse_situation from  BGP_DEVICE_INSPECTION_TEAM t  where t.inspection_team_id= '"+ids+"'"  ;
			var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'pageSize=100000&querySql='+querySql);
			retObj = queryRet.datas;
		}
		
		document.getElementById("modifi_project").value =retObj[0].modifi_project;
		document.getElementById("modifi_time").value =retObj[0].modifi_time;
		document.getElementById("modifi_person").value =retObj[0].modifi_person;
		document.getElementById("memo").value =retObj[0].memo;
		
		
		var system_situation = document.getElementsByName("system_situation");
		for(var s=0;s<system_situation.length;s++){
			if(system_situation[s].value==retObj[0].system_situation){
				system_situation[s].checked = true;
			}
		}
		var check_situation = document.getElementsByName("check_situation");
		for(var s=0;s<check_situation.length;s++){
			if(check_situation[s].value==retObj[0].check_situation){
				check_situation[s].checked = true;
			}
		}
		var device_situation = document.getElementsByName("device_situation");
		for(var s=0;s<device_situation.length;s++){
			if(device_situation[s].value==retObj[0].device_situation){
				device_situation[s].checked = true;
			}
		}
		var hse_situation = document.getElementsByName("hse_situation");
		for(var s=0;s<hse_situation.length;s++){
			if(hse_situation[s].value==retObj[0].hse_situation){
				hse_situation[s].checked = true;
			}
		}
		
		if(shuaId==null)
			shuaId = ids;
		devList(shuaId)
				
    }
    
	function devList(shuaId){
		if (shuaId != null) {
			debugger;
			var querySql = "select rownum, dui.dev_acc_id, dui.dev_name, dui.dev_model, dui.self_num, dui.license_num,f.file_id,f.file_name from bgp_comm_device_inspection di"
			+" inner join gms_device_account_dui dui on di.device_account_id = dui.dev_acc_id and dui.bsflag = '0' "
			+" left join bgp_doc_gms_file f on di.inspection_id = f.relation_id and f.bsflag = '0' "
			+" where di.bsflag='0' and di.inspection_team_id = '"+shuaId+"' order by di.modifi_date desc"; 
			
			var queryRet = syncRequest('Post', '<%=contextPath%>' + appConfig.queryListAction, 'pageSize=100000&querySql=' + querySql);
			retObj = queryRet.datas;
			var size = $("#assign_body", "#tab_box_content2").children("tr").size();
			if (size > 0) {
				$("#assign_body", "#tab_box_content2").children("tr").remove();
			}
			var jc_body1 = $("#assign_body", "#tab_box_content2")[0];
			if (retObj != undefined) {
				for (var i = 0; i < retObj.length; i++) {
				 
					var newTr = jc_body1.insertRow()
					newTr.id = retObj[i].devinspectioin_id;
				 
					newTr.insertCell().innerText = i+1;
					newTr.insertCell().innerText = retObj[i].dev_name;
					newTr.insertCell().innerText = retObj[i].dev_model;
					newTr.insertCell().innerText = retObj[i].self_num;
					newTr.insertCell().innerText = retObj[i].license_num;
					newTr.insertCell().innerHTML = "<a href='javascript:void(0)' onclick=downLoad('"+retObj[i].file_id+"')><font color='blue'>"+retObj[i].file_name+"</font></a>";
				}
			}
		}
		$("#assign_body>tr:odd>td:odd", '#tab_box_content2').addClass("odd_odd");
		$("#assign_body>tr:odd>td:even", '#tab_box_content2').addClass("odd_even");
		$("#assign_body>tr:even>td:odd", '#tab_box_content2').addClass("even_odd");
		$("#assign_body>tr:even>td:even", '#tab_box_content2').addClass("even_even");
	}
	//新增
	function toAdd(){
		popWindow('<%=contextPath %>/rm/dm/devTeamCheck/devTeamCheckEdit.jsp?flag=add');		
	}       
	//修改
	function toEdit(){ 
	    ids = getSelIds('rdo_entity_id');
	    if(ids==''){ alert("请选择记录!");
	     	return;
	    }
	    var retObj2 = jcdpCallService("DevTeamCheckSrv", "getDevTeamCheckInfo", "id="+ids);
		if(typeof retObj2.data!="undefined"){
			var edata = retObj2.data;
			if("0"!=edata.data_source){
				alert("数据来源为手持机，不能修改!");
				return;
			}
		}
		popWindow('<%=contextPath%>/rm/dm/devTeamCheck/devTeamCheckEdit.jsp?flag=edit&id='+ids);
	}
	//删除
	function toDelete(){
	    ids = getSelIds('rdo_entity_id');
	    if(ids==''){ 
	    	alert("请选择记录!");
	     	return;
	    }
	    var retObj2 = jcdpCallService("DevTeamCheckSrv", "getDevTeamCheckInfo", "id="+ids);
		if(typeof retObj2.data!="undefined"){
			var edata = retObj2.data;
			if("0"!=edata.data_source){
				alert("数据来源为手持机，不能删除!");
				return;
			}
		}
		if(confirm('确定要删除吗?')){  
			var dretObj = jcdpCallService("DevTeamCheckSrv", "deleteDevTeamCheckfo", "id="+ids);
			if(typeof dretObj.operationFlag!="undefined"){
				var dOperationFlag=dretObj.operationFlag;
				if(''!=dOperationFlag){
					if("failed"==dOperationFlag){
						alert("删除失败！");
					}	
					if("success"==dOperationFlag){
						alert("删除成功！");
						queryData(cruConfig.currentPage);
					}
				}
			}
		}
	}
	//下载文件
	function downLoad(file_id){
		window.location.href("<%=contextPath%>/doc/downloadDoc.srq?docId="+file_id);
	}
</script>

</html>
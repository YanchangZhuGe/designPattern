<%@ page contentType="text/html;charset=UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.bgp.gms.service.rm.dm.constants.DevConstants,com.bgp.gms.service.rm.dm.util.DevUtil"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%@taglib uri="wf" prefix="wf"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String projectInfoNo = user.getProjectInfoNo();
	String projectName = user.getProjectName();
	String orgSubId = user.getSubOrgIDofAffordOrg();
	String subId = user.getOrgSubjectionId();
	String userid= user.getEmpId();
 
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet"
	type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css"
	rel="stylesheet" type="text/css" />
<script type="text/javascript"
	src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript"
	src="<%=contextPath%>/pm/bpm/common/processInfoCommon.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open1.js"></script>

<title>送外维修返还单申请</title>
</head>

<body style="background: #fff" onload="refreshData()">
	<div id="list_table">
		<div id="inq_tool_box">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td width="6"><img src="<%=contextPath%>/images/list_13.png"
						width="6" height="36" /></td>
					<td background="<%=contextPath%>/images/list_15.png"><table
							width="100%" border="0" cellspacing="0" cellpadding="0">
							</tr>
							<tr>
								<td class="ali_cdn_name">返还单号</td>
								<td class="ali_cdn_input"><input
									id="s_device_backapp_no" name="s_device_backapp_no"
									type="text" class="input_width" /></td>
								<td class="ali_cdn_name">返还单名称</td>
								<td class="ali_cdn_input"><input
									id="s_device_backapp_name" name="s_device_backapp_name"
									type="text" class="input_width" /></td>
								<td class="ali_query"><span class="cx"><a href="#"
										onclick="searchDevData()" title="查询"></a></span></td>
								<td class="ali_query"><span class="qc"><a href="#"
										onclick="clearQueryText()" title="清除"></a></span></td>
								<td>&nbsp;</td>
								<auth:ListButton functionId="" css="zj"
									event="onclick='toAddDevSendRepairPage()'" title="新增"></auth:ListButton>
								<auth:ListButton functionId="" css="xg"
									event="onclick='toModifyDevRepairPage()'" title="修改"></auth:ListButton>
								<auth:ListButton functionId="" css="sc"
									event="onclick='toDelDevRepairPage()'" title="删除"></auth:ListButton>
									<auth:ListButton functionId="" css="tj"
									event="onclick='toSumbitRepairSend()'" title="提交"></auth:ListButton>
									<!-- 
									<auth:ListButton functionId="" css="dc"
									event="onclick='exportData()'" title="导出excel"></auth:ListButton>
									 -->
							</tr>
						</table></td>
					<td width="4"><img src="<%=contextPath%>/images/list_17.png"
						width="4" height="36" /></td>
				</tr>
			</table>
		</div>
		<div id="table_box">
			<table style="width: 98.5%" border="0" cellspacing="0"
				cellpadding="0" class="tab_info" id="queryRetTable">
				<tr id='id_{id}' name='id'
					idinfo='{id}'>
					<td class="bt_info_odd" 
						exp="<input type='checkbox' name='selectedbox' value='{id}' id='selectedbox_{id}' onclick='chooseOne(this)'/>">选择</td>
					<td class="bt_info_even" autoOrder="1">序号</td>
					<td class="bt_info_even" exp="{backapp_no}">返还单号</td>
					<td class="bt_info_odd" exp="{backapp_name}">返还单名称</td>
					<td class="bt_info_odd" exp="{backapp_org_name}">返还单位</td>
					<td class="bt_info_even" exp="{back_employee_name}">申请人</td>
					<td class="bt_info_even" exp="{backdate}">申请日期</td>
					<td class="bt_info_odd" exp="{status_desc}">状态</td>
				</tr>
			</table>
		</div>
		<div id="fenye_box" style="display: block">
			<table width="100%" border="0" cellspacing="0" cellpadding="0"
				id="fenye_box_table">
				<tr>
					<td align="right">第1/1页，共0条记录</td>
					<td width="10">&nbsp;</td>
					<td width="30"><img src="<%=contextPath%>/images/fenye_01.png"
						width="20" height="20" /></td>
					<td width="30"><img src="<%=contextPath%>/images/fenye_02.png"
						width="20" height="20" /></td>
					<td width="30"><img src="<%=contextPath%>/images/fenye_03.png"
						width="20" height="20" /></td>
					<td width="30"><img src="<%=contextPath%>/images/fenye_04.png"
						width="20" height="20" /></td>
					<td width="50">到 <label> <input type="text"
							name="textfield" id="textfield" style="width: 20px;" />
					</label></td>
					<td align="left"><img
						src="<%=contextPath%>/images/fenye_go.png" width="22" height="22" /></td>
				</tr>
			</table>
		</div>
		<div class="lashen" id="line"></div>
		<div id="tag-container_3">
			<ul id="tags" class="tags">
				<li class="selectTag" id="tag3_0"><a href="#"
					onclick="getContentTab(this,0)">基本信息</a></li>
				<li id="tag3_1"><a href="#" onclick="getContentTab(this,1)">明细信息</a></li>
				
				<!--  
				<li id="tag3_1"><a href="#" onclick="getContentTab(this,2)">审批明细</a></li>
				<li id="tag3_1"><a href="#" onclick="getContentTab(this,3)">附件</a></li>
				-->
				<li id="tag3_1"><a href="#" onclick="getContentTab(this,4)">备注</a></li>
				<!--  
				<li id="tag3_1"><a href="#" onclick="getContentTab(this,5)">分类码</a></li>
				-->
			</ul>
		</div>
		<div id="tab_box" class="tab_box">
			<div id="tab_box_content0" name="tab_box_content0"
				class="tab_box_content">
				<table id="projectMap" name="projectMap" border="0" cellpadding="0"
					cellspacing="0" class="tab_line_height" width="100%"
					style="margin-top: 10px; background: #efefef">
					<td class="inquire_item6">&nbsp;返还单号：</td>
					<td class="inquire_form6"><input id="backapp_no"
						class="input_width" type="text" value="" disabled /> &nbsp;</td>
					<td class="inquire_item6">返还单名称：</td>
					<td class="inquire_form6"><input id="backapp_name"
						class="input_width" type="text" value="" disabled /> &nbsp;</td>
						<td class="inquire_item6">状态：</td>
						<td class="inquire_form6"><input id="status_desc"
							class="input_width" type="text" value="" disabled /> &nbsp;</td>
					</tr>
					<tr>
						<td class="inquire_item6">&nbsp;创建人：</td>
						<td class="inquire_form6"><input id="creator_name"
							class="input_width" type="text" value="" disabled /> &nbsp;</td>
						<td class="inquire_item6">创建日期：</td>
						<td class="inquire_form6"><input id="create_date"
							class="input_width" type="text" value="" disabled /> &nbsp;</td>
					</tr>
					
				</table>
			</div>
			<div id="tab_box_content1" name="tab_box_content1" idinfo=""
				class="tab_box_content" style="display: none">
				<table border="0" cellpadding="0" cellspacing="0"
					class="tab_line_height" width="100%"
					style="margin-top: 10px; background: #efefef">
					<tr class="bt_info">
						<td class="bt_info_even">序号</td>
						<td class="bt_info_odd">设备名称</td>
						<td class="bt_info_even">规格型号</td>
						<td class="bt_info_odd">实物标识号</td>
						<td class="bt_info_odd">故障类别</td>
						<td class="bt_info_even">故障现象</td>
						<!-- <td class="bt_info_odd">设备状态</td> -->
						 <td class="bt_info_even">备注</td>
					</tr>
					<tbody id="detailMap" name="detailMap"></tbody>
				</table>
			</div>
			<div id="tab_box_content2" name="tab_box_content2"
				class="tab_box_content" style="display: none;">
				<wf:startProcessInfo buttonFunctionId="F_OP_002" title="" />
			</div>
			<div id="tab_box_content3" name="tab_box_content3"
				class="tab_box_content" style="display: none;">
				<iframe width="100%" height="100%" name="attachement"
					id="attachement" frameborder="0" src="" marginheight="0"
					marginwidth="0"></iframe>
			</div>
			<div id="tab_box_content4" name="tab_box_content4"
				class="tab_box_content" style="display: none;">
				<iframe width="100%" height="100%" name="remark" id="remark"
					frameborder="0" src="" marginheight="0" marginwidth="0"></iframe>
			</div>
			<div id="tab_box_content5" name="tab_box_content5"
				class="tab_box_content" style="display: none;">
				<iframe width="100%" height="100%" name="codeManager"
					id="codeManager" frameborder="0" src="" marginheight="0"
					marginwidth="0" scrolling="auto" style="overflow: scroll;"></iframe>
			</div>
		</div>
	</div>
</body>
<script type="text/javascript">
function frameSize(){
	//$("#tab_box").css("height",$(window).height()-$("#inq_tool_box").height()-$("#table_box").height()-$("#fenye_box").height()-60);
	setTabBoxHeight();
}
frameSize();


$(function(){
	$(window).resize(function(){
  		frameSize();
	});
})	

	var selectedTagIndex = 0;
	function getContentTab(obj,index) { 
		selectedTagIndex = index;
		if(obj!=undefined){
			$("LI","#tag-container_3").removeClass("selectTag");
			var contentSelectedTag = obj.parentElement;
			contentSelectedTag.className ="selectTag";
		}
		var filterobj = ".tab_box_content[name=tab_box_content"+index+"]";
		var filternotobj = ".tab_box_content[name!=tab_box_content"+index+"]";
		var currentid ;
		$("input[type='checkbox'][name='selectedbox']").each(function(){
			if(this.checked){
				currentid = this.value;
			}
		});
		if(index == 1){
			//动态查询明细
			var idinfo = $(filterobj).attr("idinfo");
			if(currentid != undefined && idinfo == currentid){
				//已经有值，且完成钻取，那么不再钻取
			}else{
				//先进行查询
				var str = 
					"SELECT ACC.DEV_NAME AS DEV_NAME,\n" +
					"       ACC.DEV_TYPE AS DEV_TYPE,\n" + 
					"       ACC.DEV_MODEL AS DEV_MODEL,\n" + 
					"       DECODE(SUB.ERROR_TYPE, <%=DevUtil.getDecodeStr(DevConstants.DECODE_KEY_ERRORTYPE)%>) as ERROR_TYPE,\n" + 
					"       DECODE(SUB.ERROR_DESC,\n" + 
					"        <%=DevUtil.getDecodeStr(DevConstants.DECODE_KEY_ERRORDESC)%>) AS ERROR_DESC,\n" + 
					"       ACC.DEV_SIGN AS DEV_SIGN,\n" + 
					"       DECODE(SUB.DEV_STATUS,\n" + 
					"        <%=DevUtil.getDecodeStr(DevConstants.DECODE_KEY_DEVSTATUS)%>) AS DEV_STATUS,\n" + 
					"       SUB.REMARK AS REMARK\n" + 
					"  FROM GMS_DEVICE_COL_REP_DETAIL  D,\n" + 
					"       GMS_DEVICE_COL_REP_FORM    F,\n" + 
					"       GMS_DEVICE_COLL_SEND_SUB    SUB,\n" + 
					"       GMS_DEVICE_ACCOUNT_B        ACC,\n" + 
					"       GMS_DEVICE_COLL_REPAIR_SEND SEND\n" + 
					" WHERE SUB.BSFLAG = '0'\n" + 
					"   AND ACC.BSFLAG = '0'\n" + 
					"   AND D.REP_RETURN_ID = F.ID(+)\n" + 
					"   AND D.REP_FORM_DET_ID = SUB.ID(+)\n" + 
					"   AND SUB.DEV_ACC_ID = ACC.DEV_ACC_ID(+)\n" + 
					"   AND SUB.SEND_FORM_ID = SEND.ID(+)\n" + 
					"   AND F.ID = '"+currentid+"'" +
					"";
<%--					"  union " +--%>
<%--					"SELECT ACC.DEV_NAME AS DEV_NAME,\n" +--%>
<%--					"       ACC.DEV_TYPE AS DEV_TYPE,\n" + --%>
<%--					"       ACC.DEV_MODEL AS DEV_MODEL,\n" + --%>
<%--					"       DECODE(SUB.ERROR_TYPE, <%=DevUtil.getDecodeStr(DevConstants.DECODE_KEY_ERRORTYPE)%>) as ERROR_TYPE,\n" + --%>
<%--					"       DECODE(SUB.ERROR_DESC,\n" + --%>
<%--					"        <%=DevUtil.getDecodeStr(DevConstants.DECODE_KEY_ERRORDESC)%>) AS ERROR_DESC,\n" + --%>
<%--					"       ACC.DEV_SIGN AS DEV_SIGN,\n" + --%>
<%--					"       DECODE(SUB.DEV_STATUS,\n" + --%>
<%--					"        <%=DevUtil.getDecodeStr(DevConstants.DECODE_KEY_DEVSTATUS)%>) AS DEV_STATUS,\n" + --%>
<%--					"       SUB.REMARK AS REMARK\n" + --%>
<%--					"  FROM GMS_DEVICE_COL_REP_DETAIL  rtnD,\n" + --%>
<%--					"       GMS_DEVICE_COLL_REPAIR_SUB SUB,\n" + --%>
<%--					"       GMS_DEVICE_ACCOUNT_B       ACC,\n" + --%>
<%--					"       GMS_DEVICE_COLL_REPAIRFORM REP,\n" + --%>
<%--					"       COMM_ORG_INFORMATION       REQORG,\n" + --%>
<%--					"       GMS_DEVICE_COL_REP_FORM    RTN\n" + --%>
<%--					" WHERE SUB.BSFLAG = '0'\n" + --%>
<%--					"   AND ACC.BSFLAG = '0'\n" + --%>
<%--					"   AND rtnD.BSFLAG = '0'\n" + --%>
<%--					"   AND rtnD.REP_FORM_DET_ID = SUB.ID(+)\n" + --%>
<%--					"   AND SUB.DEV_ACC_ID = ACC.DEV_ACC_ID(+)\n" + --%>
<%--					"   AND SUB.REPAIRFORM_ID = REP.ID(+)\n" + --%>
<%--					"   AND REP.REQ_COMP = REQORG.ORG_ID(+)\n" + --%>
<%--					"   AND rtnD.Rep_Return_Id = RTN.Id(+)" +--%>
<%--					"   AND RTN.ID = '"+currentid+"'";--%>
				var queryRet = encodeAndsyncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+str);
				basedatas = queryRet.datas;
				if(basedatas!=undefined && basedatas.length>=1){
					//先清空
					var filtermapid = "#detailMap";
					$(filtermapid).empty();
					appendDataToDetailTab(filtermapid,basedatas);
					//设置当前标签页显示的主键
					$(filterobj).attr("idinfo",currentid);
				}else{
					var filtermapid = "#detailMap";
					$(filtermapid).empty();
					$(filterobj).attr("idinfo",currentid);
				}
			}
		}
		else if(index == 3){
			$("#attachement").attr("src","<%=contextPath%>/doc/common/common_doc_list.jsp?relationId="+currentid);
		}else if(index == 4){
			$("#remark").attr("src","<%=contextPath%>/common/remark/relatedOperation.srq?foreignKeyId="+currentid);
		}else if(index == 5){
			$("#codeManager").attr("src","<%=contextPath%>/pm/projectCode/projectCodeAssignment.jsp?owner=5&relationId="+currentid);
		}
		$(filternotobj).hide();
		$(filterobj).show();
	}
	function appendDataToDetailTab(filterobj,datas){
		for(var i=0;i<basedatas.length;i++){
			var innerHTML = "<tr>";
			innerHTML += "<td>"+(i+1)+"</td>";
			innerHTML += "<td>"+datas[i].dev_name+"</td><td>"+datas[i].dev_model+"</td>";
			innerHTML += "<td>"+datas[i].dev_sign+"</td>";
			innerHTML += "<td>"+datas[i].error_type+"</td><td>"+datas[i].error_desc+"</td>";
			//<td>"+datas[i].dev_status+"</td>
			innerHTML += "<td>"+datas[i].remark+"</td>";
			innerHTML += "</tr>";
			$(filterobj).append(innerHTML);
		}
		$(filterobj+">tr:odd>td:odd").addClass("odd_odd");
		$(filterobj+">tr:odd>td:even").addClass("odd_even");
		$(filterobj+">tr:even>td:odd").addClass("even_odd");
		$(filterobj+">tr:even>td:even").addClass("even_even");
	}
	$(document).ready(lashen);
</script>

<script type="text/javascript">
	var projectInfoNos = '<%=projectInfoNo%>';
	var projectName = '<%=projectName%>';
	cruConfig.contextPath =  "<%=contextPath%>";
	cruConfig.cdtType = 'form';
	
	function getdate() { 
		var   now=new   Date() 
		y=now.getFullYear() 
		m=now.getMonth()+1 
		d=now.getDate() 
		m=m <10? "0"+m:m 
		d=d <10? "0"+d:d 
		return   y + "-" + m + "-" + d ;
	}
	function searchDevData(){
		var v_device_repair_app_no = document.getElementById("s_device_backapp_no").value;
		var v_device_repair_app_name = document.getElementById("s_device_backapp_name").value;
		refreshData(v_device_repair_app_no, v_device_repair_app_name);
	}
	function clearQueryText(){
		document.getElementById("s_device_backapp_no").value = "";
		document.getElementById("s_device_backapp_name").value = "";
	}
    function refreshData(v_device_repair_app_no, v_device_repair_app_name){
		var str = 
			"SELECT RFORM.*,\n" +
			"       EMP.EMPLOYEE_NAME AS BACK_EMPLOYEE_NAME,\n" + 
			"       DECODE(RFORM.STATUS, 0, '编制', 1, '生效' ，2, '作废', '无效状态') AS STATUS_DESC\n" + 
			"  FROM GMS_DEVICE_COL_REP_FORM     RFORM,\n" + 
			"       COMM_HUMAN_EMPLOYEE         EMP\n" + 
			" WHERE 1 = 1 AND RFORM.BSFLAG = 0 \n" + 
			"   AND RFORM.BACK_EMPLOYEE_ID = EMP.EMPLOYEE_ID(+)\n" + 
			"  AND RFORM.REP_TYPE='1' ";
		//org_subjection_id like '<%=subId%>%' "; //liug是否需要控制机构
		if(v_device_repair_app_no!=undefined && v_device_repair_app_no!=''){//根据送修单号查询
			str += " AND RFORM.backapp_no like '%"+v_device_repair_app_no+"%' ";
		}
		if(v_device_repair_app_name!=undefined && v_device_repair_app_name!=''){//根据送修单名称查询
			str += " and RFORM.backapp_name like '%"+v_device_repair_app_name+"%' ";
		}
		 	str += "and emp.employee_id='<%=userid%>'";
			str += " ORDER BY RFORM.STATUS,RFORM.CREATE_DATE DESC";
		cruConfig.queryStr = str;
		queryData(cruConfig.currentPage);;
	}
    function loadDataDetail(id){
    	var retObj;
		if(id!=null){
			 retObj = jcdpCallService("DevCommInfoSrv", "getDevSendRepairRtnBaseInfo", "id="+id);
			
		}else{
			var ids = getSelIds('selectedbox');
		    if(ids==''){ 
			    alert("请先选中一条记录!");
	     		return;
		    }
		    retObj = jcdpCallService("DevCommInfoSrv", "getDevSendRepairRtnBaseInfo", "id="+ids);
		}
		//选中这一条checkbox
		$("#selectedbox_"+retObj.deviceSendRepairRtnMap.id).attr("checked","checked");
		//取消其他选中的
		$("input[type='checkbox'][name='selectedbox'][id!='selectedbox_"+retObj.deviceSendRepairRtnMap.id+"']").removeAttr("checked");
		//给数据回填
		$("#backapp_no","#projectMap").val(retObj.deviceSendRepairRtnMap.backapp_no);
		$("#backapp_name","#projectMap").val(retObj.deviceSendRepairRtnMap.backapp_name);
		$("#backapp_org_name","#projectMap").val(retObj.deviceSendRepairRtnMap.backapp_org_name);
		$("#creator_name","#projectMap").val(retObj.deviceSendRepairRtnMap.creator_name);
		$("#create_date","#projectMap").val(retObj.deviceSendRepairRtnMap.create_date);
		$("#status_desc","#projectMap").val(retObj.deviceSendRepairRtnMap.status_desc);
		getContentTab(undefined,selectedTagIndex);
		/**
		var device_repair_name = retObj.deviceSendRepairRtnMap.repair_form_name;
		var device_repair_no = retObj.deviceSendRepairRtnMap.toModifyDevRepairPage;
		//重新加载当前标签页信息
		getContentTab(undefined,selectedTagIndex);
		//工作流信息
		var submitdate =getdate();
    	processNecessaryInfo={        							//流程引擎关键信息
			businessTableName:"GMS_DEVICE_COLL_REPAIR_SEND",    			//置入流程管控的业务表的主表表明
			businessType:"5110000004100001034",    				//业务类型 即为之前设置的业务大类
			businessId:repair_send_id,           			//业务主表主键值
			businessInfo:"送修审批流程<送修单名称:"+device_repair_name+";送修单号:"+device_repair_no+">",
			applicantDate:submitdate       						//流程发起时间
		};
		processAppendInfo={ 
			projectName:projectName,									//流程引擎附加临时变量信息
			projectInfoNo:projectInfoNos,
			devicehireappid:repair_send_id
		};
		
		loadProcessHistoryInfo();
		**/
    }
	function toAddDevSendRepairPage(){
		popWindow('<%=contextPath%>/rm/dm/devRepair/repairSendRtnNewApply.jsp');
	}
	function toModifyDevRepairPage(){
		var length = 0;
		var selectedid = "";
		$("input[type='checkbox'][name='selectedbox']").each(function(){
			if(this.checked){
				if(length!=0){
					selectedid += ",";
				}
				selectedid += "'"+this.value+"'";
				length = length+1;
			}
		});
		if(length == 0){
			alert("请选择记录!");
			return;
		}else if(length != 1 ){
			alert("请选择一条记录!");
			return;
		}
		//判断状态
		//判断状态
		var querySql = 
			"SELECT T.STATUS FROM GMS_DEVICE_COL_REP_FORM T\n" +
			"WHERE T.ID IN ("+selectedid+")";
		var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql);
		var basedatas = queryRet.datas;
		
		var stateflag = false;
		var alertinfo ;
		for(var index = 0;index<basedatas.length;index++){
			if(basedatas[index].status == '1' ){
				stateflag = true;
				alertinfo = "您选择的记录中存在状态为'生效'的单据,不能修改!";
				break;
			}else if(basedatas[index].status == '2' ){
				stateflag = true;
				alertinfo = "您选择的记录中存在状态为'作废'的单据,不能修改!";
				break;
			}
		}
		if(stateflag){
			alert(alertinfo);
			return;
		}
		var id ;
		$("input[type='checkbox'][name='selectedbox']").each(function(){
			if(this.checked){
				id = this.value;
			}
		});
		popWindow('<%=contextPath%>/rm/dm/devRepair/repairSendRtnModify.jsp?id=' + id);
	}
	function toDelDevRepairPage(){
		var length = 0;
		var selectedid = "";
		$("input[type='checkbox'][name='selectedbox']").each(function(){
			if(this.checked){
				if(length!=0){
					selectedid += ",";
				}
				selectedid += "'"+this.value+"'";
				length = length+1;
			}
		});
		if(length == 0){
			alert("请选择记录！");
			return;
		}
		//判断状态
		var querySql = 
			"SELECT T.STATUS FROM GMS_DEVICE_COL_REP_FORM T\n" +
			"WHERE T.ID IN ("+selectedid+")";
		var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql);
		var basedatas = queryRet.datas;
		
		var stateflag = false;
		var alertinfo ;
		for(var index = 0;index<basedatas.length;index++){
			if(basedatas[index].status == '1' ){
				stateflag = true;
				alertinfo = "您选择的记录中存在状态为'生效'的单据,不能删除!";
				break;
			}else if(basedatas[index].status == '2' ){
				stateflag = true;
				alertinfo = "您选择的记录中存在状态为'作废'的单据,不能删除!";
				break;
			}
		}
		if(stateflag){
			alert(alertinfo);
			return;
		}
		//什么状态不能删除，和业务专家确定
		if(confirm("是否执行删除操作?")){
			var sql = "update GMS_DEVICE_COL_REP_FORM set bsflag='1' where id in ("+selectedid+")";
			var sql1 = "update GMS_DEVICE_COL_REP_DETAIL set bsflag='1' where REP_RETURN_ID in ("+selectedid+")";
			var path = cruConfig.contextPath+"/rad/asyncDelete.srq";
			var params = "deleteSql="+sql;
			params += "&ids=";
			var params1 = "deleteSql="+sql1;
			params1 += "&ids=";
			var retObject = syncRequest('Post',path,params);
			var retObject1 = syncRequest('Post',path,params1);
			refreshData();
		}
	}
	function toSumbitRepairSend(){
		var length = 0;
		var selectedid = "";
		$("input[type='checkbox'][name='selectedbox']").each(function(){
			if(this.checked){
				if(length!=0){
					selectedid += ",";
				}
				selectedid += "'"+this.value+"'";
				length = length+1;
			}
		});
		if(length == 0){
			alert("请选择记录！");
			return;
		}
		//判断状态
		var querySql = 
			"SELECT T.STATUS FROM GMS_DEVICE_COL_REP_FORM T\n" +
			"WHERE T.ID IN ("+selectedid+")";
		var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql);
		var basedatas = queryRet.datas;
		
		var stateflag = false;
		var alertinfo ;
		for(var index = 0;index<basedatas.length;index++){
			if(basedatas[index].status == '1' ){
				stateflag = true;
				alertinfo = "您选择的记录中存在状态为'生效'的单据,不能提交!";
				break;
			}else if(basedatas[index].status == '2' ){
				stateflag = true;
				alertinfo = "您选择的记录中存在状态为'作废'的单据,不能提交!";
				break;
			}
		}
		if(stateflag){
			alert(alertinfo);
			return;
		}
		//查看是否添加了明细
		var querySql = "SELECT COUNT(1) as SUMNUM FROM GMS_DEVICE_COL_REP_DETAIL T\n" +
			"WHERE T.BSFLAG = 0 AND T.REP_RETURN_ID in("+selectedid+") ";
		var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql);
		var basedatas = queryRet.datas;
		var detflag = false;
		for(var index = 0;index<basedatas.length;index++){
			if(basedatas[index].sumnum == 0 ){
				detflag = true;
				alertinfo = "您选择的记录中未添加明细,不能提交!";
			}
		}
		if(detflag){
			alert(alertinfo);
			return;
		}
		if (window.confirm("确认要提交吗?")) {
			//将送修表的编制状态改为生成
			var sql = "update GMS_DEVICE_COL_REP_FORM set status='1' where ID in ("+selectedid+")";
			var path = cruConfig.contextPath+"/rad/asyncDelete.srq";
			var params = "deleteSql="+sql;
			params += "&ids=";
			//accparams += "&ids=";
			syncRequest('Post',path,params);
			//向设备动态表添加数据
			//document.getElementById("form1").action = "<%=contextPath%>/rm/dm/devRepair/repairSendReturnListSubmit.srq?formid="+selectedid;
			retObj = jcdpCallService("DevCommInfoSrv", "repairSendReturnListSubmit", "formid="+selectedid);
			/********************** 将设备表的状态改掉 */  
			//更新设备表中数据的状态 0110000007000000002 使用状态闲置   技术状态 0110000006000000001  完好
			var accsql = 
				"UPDATE GMS_DEVICE_ACCOUNT_B ACC\n" +
				"   SET ACC.TECH_STAT  = '0110000006000000001',\n" + 
				"       ACC.USING_STAT = '0110000007000000002'\n" + 
				" WHERE EXISTS (SELECT 1\n" + 
				"          FROM GMS_DEVICE_COL_REP_FORM    form,\n" + 
				"               GMS_DEVICE_COL_REP_DETAIL  det,\n" + 
				"               GMS_DEVICE_COLL_SEND_SUB sub\n" + 
				"         WHERE ACC.DEV_ACC_ID = SUB.DEV_ACC_ID(+)\n" + 
				"           AND SUB.id = det.rep_form_det_id(+)\n" + 
				"           and det.rep_return_id = form.id(+)\n" + 
				"           and det.bsflag = '0'\n" + 
				"           and sub.bsflag = '0'" +
				"           AND form.ID IN ("+selectedid+")) ";
			var path = cruConfig.contextPath+"/rad/asyncDelete.srq";
			var accparams = "deleteSql="+accsql;
			accparams += "&ids=";
			syncRequest('Post',path,accparams);
			/***********************/
			alert('提交成功!');
			refreshData();
		}
	}
	
	function toModifyDetail(obj){
		alert("88");
		var idinfo = null;
		if(obj!=undefined){
			idinfo = obj.idinfo;
		}else{
			$("input[type='checkbox'][name='selectedbox']").each(function(){
				if(this.checked){
					idinfo = this.value;
				}
			});
		}
		window.location.href='<%=contextPath%>/rm/dm/hireplan/hirePlanDetailList.jsp?projectInfoNo=<%=projectInfoNo%>&devicehireappid='+idinfo;
	}
	//function dbclickRow(shuaId){
	//	window.location.href='<%=contextPath%>/rm/dm/hireplan/hirePlanDetailList.jsp?projectInfoNo=<%=projectInfoNo%>&devicehireappid='+shuaId;
	//}
	function chooseOne(cb) {
		var obj = document.getElementsByName("rdo_entity_id");
		for (i = 0; i < obj.length; i++) {
			if (obj[i] != cb)
				obj[i].checked = false;
			else
				obj[i].checked = true;
		}
	}
</script>
</html>
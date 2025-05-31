<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@page import="java.util.*"%>
<%@ page import="java.text.*" %>
<%@ taglib uri="code" prefix="code"%> 
<%@taglib prefix="auth" uri="auth"%>
<%@ taglib uri="wf" prefix="wf"%>
<%
	String contextPath = request.getContextPath();

UserToken user = OMSMVCUtil.getUserToken(request);
String projectType = user.getProjectType();//项目类型

	ISrvMsg respMsg = OMSMVCUtil.getResponseMsg(request);
	String projectInfoNo = request.getParameter("projectInfoNo");
	
	if(projectInfoNo == null || "".equals(projectInfoNo)){

		projectInfoNo = user.getProjectInfoNo();
	}
	SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	String appDate = df.format(new Date());
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<script src="<%=contextPath%>/js/prototype.js"></script>
<script src="<%=contextPath%>/js/verify.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/common.js"></script>
<link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" />
<script type="text/javascript" src="<%=contextPath%>/pm/bpm/common/processInfoCommon.js"></script>
<title>项目计划列表</title>
</head>

<body onload="refreshData();" style="background:#fff">
	<input type="hidden" id="key_object_id" name="key_object_id" value=""></input>
      	<div id="list_table">
			<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td>&nbsp;</td>	
				<auth:ListButton functionId="" css="zj" event="onclick='toAdd()'" title="新增"></auth:ListButton>
				<auth:ListButton functionId="" css="sc" event="onclick='toDelete()'" title="删除"></auth:ListButton>
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
			      <td class="bt_info_odd" exp="<input type='checkbox' name='rdo_entity_id' value='{project_info_no}:{object_id}:{base_plan_id}:{plan_name}:{proc_status_value}:{project_name}:{baseline_plan_object_id}' id='rdo_entity_id_{project_info_no}' onclick=doCheck(this)/> <input type='hidden' name='addflag' value='{add_flag}'/>" >选择</td>
			      <td class="bt_info_even" autoOrder="1">序号</td>
			      <td class="bt_info_odd" exp="{project_name}" >项目名称</td>
			      <td class="bt_info_even" exp="{plan_name}" >计划版本</td>
			      <td class="bt_info_odd" exp="{team_id}" >施工队伍</td>
			      <td class="bt_info_even" exp="{create_date}" >创建日期</td>
			      <td class="bt_info_odd" exp="{proc_status}" >状态</td>
			    </tr>
			  </table>
			</div>
			<div id="fenye_box"><table width="100%" border="0" cellspacing="0" cellpadding="0" id="fenye_box_table">
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
			      </label></td>
			    <td align="left"><img src="<%=contextPath%>/images/fenye_go.png" width="22" height="22" /></td>
			  </tr>
			</table>
			</div>
			<div class="lashen" id="line"></div>
			<div id="tag-container_3">
			  <ul id="tags" class="tags">
			    <li class="selectTag" id="tag3_0"><a href="#" onclick="getTab3(0)">审批流程</a></li>
			    <li id='tag3_1'><a href="#" onclick="getTab3(1)">文档</a></li>
			  </ul>
			</div>
			
			<div id="tab_box" class="tab_box">
				<div id="tab_box_content0" class="tab_box_content">
					<wf:startProcessInfo   title=""/>
				</div>
				<div id="tab_box_content1" class="tab_box_content" style="display:none;">
					<div style="overflow:auto">
				      	<table width="97%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
						  	<tr align="right">
						  		<td class="ali_cdn_name" ></td>
						  		<td class="ali_cdn_input" ></td>
						  		<td class="ali_cdn_name" ></td>
						  		<td class="ali_cdn_input" ></td>
						  		<td>&nbsp;</td>
						    	<auth:ListButton functionId="" css="zj" event="onclick='toAddWD()'" title="JCDP_btn_add"></auth:ListButton>
								<auth:ListButton functionId="" css="sc" event="onclick='toDeleteWD()'" title="JCDP_btn_delete"></auth:ListButton>
							</tr>
						  </table>
					  </div>
					<table id="wdMap" width="250%" border="0" cellspacing="0" cellpadding="0" class="tab_info" style="margin-top:2px;" >
						<tr>   
						<td class="bt_info_odd">选择</td>          
					    <td class="bt_info_even" >文档名称</td>
					    <td class="bt_info_odd">创建人</td>
					    <td class="bt_info_even">创建时间</td>
					  </tr>
					  <tbody id="assign_body"></tbody>
					</table>
				</div>
		  </div>

</body>
<script type="text/javascript" >

function frameSize(){
	setTabBoxHeight();
}
frameSize();


$(function(){
	$(window).resize(function(){
  		frameSize();
	});
})	

$(document).ready(lashen);
</script>

<script type="text/javascript">


	var projectInfoNo = '<%=projectInfoNo%>';
	var projectType ="<%=projectType %>";	//项目类型
	var serviceName="";	//调用后台的服务名
	var operationName="";	//调用后台的的方法名
	var tableName="";
	var businessType="";

	cruConfig.contextPath =  "<%=contextPath%>";
	cruConfig.cdtType = 'form';
	cruConfig.queryStr = "";
	

	
	function refreshData(){
		
		cruConfig.queryService = "ProjectPlanSrv";
		cruConfig.queryOp = "getAllPlanList";
		tableName="bgp_pm_project_plan";
		businessType="5110000004100001044";
		cruConfig.submitStr = "projectInfoNo="+projectInfoNo+"&businessType="+businessType;
		queryData(1);	
		selectWD("");
	}

	
	// 简单查询
	function simpleRefreshData(){
		var q_projectName = document.getElementById("projectName").value;
		refreshData(q_projectName, orgSubjectionId);
	}
	
	function loadDataDetail(ids){

		
		var objectId = ids.split(":")[1];
		var id = ids.split(":")[0];//项目编号
		var project_plan_name = ids.split(":")[3]; //计划名称
		var project_name = ids.split(":")[5]; //项目名称

		
		if(objectId==""){
			return;
		}
		
		processNecessaryInfo={
				businessTableName:"bgp_pm_project_plan",
				businessType:"5110000004100001047",
				businessId:objectId,
				businessInfo:"项目进度计划审批",
				applicantDate:"<%=appDate%>"
		};
		processAppendInfo={
				action:'view',
				projectInfoNo:id,
				projectName:project_name,
				planName:project_plan_name
		};
		loadProcessHistoryInfo();
		selectWD(objectId);
		document.getElementById("key_object_id").value = objectId;
	}
	
	
	var selectedTagIndex = 0;//document.getElementById("tag3_0").parentElement;
	var showTabBox = document.getElementById("tab_box_content0");

	function toAdd(){
		var add_flag = document.getElementsByName("addflag")[0];
		if(add_flag !=null && add_flag.value =='0'){
			alert("初始计划没有保存,不能创建变更计划!");
			return;
		}else{
			location.href = "<%=contextPath%>/pm/plan/planchangelist/index.jsp?projectInfoNo=<%=projectInfoNo %>";
		}
	}
	
	function toDelete(){
	    ids = getSelIds('rdo_entity_id');
	    if(ids==''){ 
	    	alert("请先选中一条记录!");
	     	return;
	    }
	    if(ids.split(",").length != 1){
	    	alert("只能删除一条记录!");
	    	return;
	    }
		var project_info_no = ids.split(":")[0];
		var object_id = ids.split(":")[1];
		var base_plan_id = ids.split(":")[2];
		var proc_status_value = ids.split(":")[4];
		var baseline_plan_object_id = ids.split(":")[6];
		if(base_plan_id == ""){
			alert("初始计划不能删除!");
			return;
		}else{
			if(proc_status_value == "1"){
				alert("已提交,不能删除!");
				return;
			}else if(proc_status_value == "3"){
				alert("已审批通过,不能删除!");
				return;
			}else{
				if(confirm('确定要删除吗?')){  
					var retObj = jcdpCallService(serviceName, "deleteProjectPlan", "objectId="+object_id+"&projectInfoNo="+project_info_no+"&basePlanId="+base_plan_id+"&baselinePlanObjectId="+baseline_plan_object_id);
					if(retObj.actionStatus != 'ok'){
						alert("删除操作失败!");
					}
					queryData(cruConfig.currentPage);
				}

			}
		}
	}
	
	function dbclickRow(ids){
		var project_info_no = ids.split(":")[0];
		var base_plan_id = ids.split(":")[2];
		var proc_status_value = ids.split(":")[4];
		if(proc_status_value == "" || proc_status_value == "4"){
			//未提交和审批不通过状态,可以修改
			if(base_plan_id == ""){
				//popWindow('<%=contextPath%>/pm/plan/planchangelist/editindex.jsp?projectInfoNo='+project_info_no);
				location.href = "<%=contextPath%>/pm/plan/planchangelist/editindex.jsp?projectInfoNo="+project_info_no;
			}else{
				//popWindow('<%=contextPath%>/pm/plan/planchangelist/editindex.jsp?projectInfoNo='+project_info_no+'&basePlanId='+base_plan_id);
				location.href = "<%=contextPath%>/pm/plan/planchangelist/editindex.jsp?projectInfoNo="+project_info_no+"&basePlanId="+base_plan_id;
			}
		}else if(proc_status_value == "1" || proc_status_value == "3"){
			//待审批和审批通过状态,不可修改
			if(base_plan_id == ""){
				//popWindow('<%=contextPath%>/pm/plan/planchangelist/planListView.jsp?projectInfoNo='+project_info_no);
				location.href = "<%=contextPath%>/pm/plan/planchangelist/planListView.jsp?projectInfoNo="+project_info_no;
			}else{
				//popWindow('<%=contextPath%>/pm/plan/planchangelist/planListView.jsp?projectInfoNo='+project_info_no+'&basePlanId='+base_plan_id);
				location.href = "<%=contextPath%>/pm/plan/planchangelist/planListView.jsp?projectInfoNo="+project_info_no+"&basePlanId="+base_plan_id;
			}
		}else if(proc_status_value == "0"){
			//popWindow('<%=contextPath%>/pm/plan/planchangelist/editindex.jsp?projectInfoNo='+project_info_no+'&notSaved=1');
			location.href = "<%=contextPath%>/pm/plan/planchangelist/editindex.jsp?projectInfoNo="+project_info_no+"&notSaved=1";
		}
	}
	
	
	function selectWD(shuaId){
		var retObj;
		var querySql="select t.file_id,t.file_name,t.ucm_id,to_char(t.create_date,'yyyy-MM-dd') create_date,e.user_name from bgp_doc_gms_file t left join p_auth_user e on t.creator_id=e.user_id and e.bsflag='0'  where t.bsflag='0' and t.is_file='1' and t.project_info_no='<%=projectInfoNo%>' and t.relation_id='"+shuaId+"'  order by t.modifi_date desc ";
		var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'pageSize=100000&querySql='+querySql);
		retObj= queryRet.datas;
		debugger;
		var size = $("#assign_body", "#tab_box_content1").children("tr").size();
		if (size > 0) {
			$("#assign_body", "#tab_box_content1").children("tr").remove();
		}
		var by_body1 = $("#assign_body", "#tab_box_content1")[0];
		if (retObj != undefined) {
			for (var i = 0; i < retObj.length; i++) {
				var newTr = by_body1.insertRow();
				newTr.insertCell().innerHTML = "<input type='checkbox' id='file_id"+retObj[i].file_id+"' name='file_checkbox_id' value='"+retObj[i].file_id+"'/>";
				var newTd = newTr.insertCell();
				newTd.innerHTML = "<a href=<%=contextPath%>/doc/downloadDocByUcmId.srq?docId="+retObj[i].ucm_id+"&emflag=0>"+retObj[i].file_name+"</a>";
				var newTd1 = newTr.insertCell();
				newTd1.innerText = retObj[i].user_name;
				var newTd2 = newTr.insertCell();
				newTd2.innerText = retObj[i].create_date;
				$("#assign_body>tr:odd>td:odd",'#tab_box_content1').addClass("odd_odd");
				$("#assign_body>tr:odd>td:even",'#tab_box_content1').addClass("odd_even");
				$("#assign_body>tr:even>td:odd",'#tab_box_content1').addClass("even_odd");
				$("#assign_body>tr:even>td:even",'#tab_box_content1').addClass("even_even");
			}
		}
	}   	
	
	function toAddWD(){
		//打开事故新增界面
	 	ids = getSelIds('rdo_entity_id');
	    if(ids==''){ 
	    	alert("请先选中一条记录!");
	     	return;
	    }
	    var objectId = ids.split(":")[1];
	 	popWindow("<%=contextPath%>/pm/plan/planchangelist/ws/add_docModify.jsp?fileAbbr=JHGL&ids="+objectId); 
	}
	
	function toDeleteWD(){
		//打开事故新增界面
	 	ids = getSelIds('file_checkbox_id');
	    if(ids==''){ 
	    	alert("请先选中一条记录!");
	     	return;
	    }
	    if(confirm('确定要删除吗?')){  
			var retObj = jcdpCallService("ProjectPlanSrv", "deleteSingleDocJH", "file_id="+ids);
			queryData(cruConfig.currentPage);
			var key_object_id = document.getElementById("key_object_id").value;
			selectWD(key_object_id);
		}
	}	
	
</script>

</html>


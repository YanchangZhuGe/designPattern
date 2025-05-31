<%@ page contentType="text/html;charset=UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%@taglib uri="wf" prefix="wf"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String projectInfoNo = request.getParameter("projectInfoNo");
	String deviceappid = request.getParameter("deviceappid");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open1.js"></script>
<title>已添加的设备调剂明细页面</title> 
</head> 
<body style="background:#fff" onload="refreshData()">
<div id="new_table_box" style="width:98%">
  <div id="new_table_box_content" style="width:100%">
    <div id="new_table_box_bg" style="width:95%">
      <fieldset style="margin-left:0px"><legend >调剂计划基本信息</legend>
      	<table border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
        	<tr>
        		<td class="inquire_item4" >项目名称:</td>
          		<td class="inquire_form4" ><input type="text" id="txt_project_name" class="input_width" readonly/></td>
          		<td class="inquire_item4" >调剂申请单号:</td>
          		<td class="inquire_form4" ><input type="text" id="txt_apply_form_num" class="input_width" readonly/></td>
        	</tr>
        	<tr>
        		<td class="inquire_item4" >调剂申请单名称:</td>
          		<td class="inquire_form4" ><input type="text" id="txt_apply_form_name"  class="input_width" readonly/></td>
          		<td class="inquire_item4" >申请单位名称:</td>
          		<td class="inquire_form4" ><input type="text" id="txt_apply_org"  class="input_width" readonly/></td>
        	</tr>
        </table>
      </fieldset>
		<fieldset style="margin-left:0px"><legend >调剂计划明细信息</legend>
			<div >
			  <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">		
			     <tr id='device_appdet_id_{device_app_detid}' name='device_app_detid'>
					<td class="bt_info_even" >序号</td>
					<td class="bt_info_odd" >班组</td>
					<td class="bt_info_even" >设备名称</td>
					<td class="bt_info_odd" >规格型号</td>
					<td class="bt_info_even" >单位</td>
					<td class="bt_info_odd" >申请数量</td>
					<td class="bt_info_even" >申请人</td>
					<td class="bt_info_odd" >用途</td>
					<td class="bt_info_even" >计划开始时间</td>
					<td class="bt_info_odd" >计划结束时间</td>
			     </tr>
			     <tbody id="detlist"></tbody>
			  </table>
			</div>
		</fieldset>
		<fieldset style="margin-left:0px"><legend >审批信息</legend>
			<form name="form1" id="form1" method="post" action="">
			<table>
				<tr>
					<td width="20%" align="right" valign="top">意见:</td>
					<td width="80%">
					<input type="hidden" name="device_app_id" value="<%=deviceappid%>">
					<textarea id="leaderinfo" name="leaderinfo" cols="60" rows="2"></textarea></td>
				</tr>
			</table>
			<div id="tab_box_content1" name="tab_box_content1" class="tab_box_content" style="display:none;">
				<wf:getProcessInfo />
			</div>
			</form>
		</fieldset>
	 </div>
	 <div id="oper_div">
     	<span class="qc" title="审批不通过"><a href="#" onclick="submitInfo(0)"></a></span>
	   	<span class="tj" title="审批通过"><a href="#" onclick="submitInfo(1)"></a></span>
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
		if(index == 3){
			$("#attachement").attr("src","<%=contextPath%>/doc/common/common_doc_list.jsp?relationId="+currentid);
		}else if(index == 4){
			$("#remark").attr("src","<%=contextPath%>/common/remark/relatedOperation.srq?foreignKeyId="+currentid);
		}else if(index == 5){
			$("#codeManager").attr("src","<%=contextPath%>/pm/projectCode/projectCodeAssignment.jsp?owner=5&relationId="+currentid);
		}
		
		$(filternotobj).hide();
		$(filterobj).show();
}
</script>
 
<script type="text/javascript">

	cruConfig.contextPath =  "<%=contextPath%>";
	cruConfig.cdtType = 'form';
	var projectInfoNos = '<%=projectInfoNo%>';
	var idinfo = '<%=deviceappid%>';

	function refreshData(v_dev_ci_name,v_dev_ci_model){
		//获取调剂基本信息
		retObj = jcdpCallService("DispensingDevSrv","getDisAppBaseInfo","deviceappid="+idinfo);
		if(retObj.deviceappMap != null){
			document.getElementById("txt_project_name").value = retObj.deviceappMap.project_name;
			document.getElementById("txt_apply_form_num").value = retObj.deviceappMap.device_app_no;
			document.getElementById("txt_apply_form_name").value = retObj.deviceappMap.device_app_name;
			document.getElementById("txt_apply_org").value = retObj.deviceappMap.org_name;
		}
		//回填明细信息
		var str = "select appdet.device_app_detid,appdet.project_info_no,sd.coding_name as unitname,teamsd.coding_name as teamname, ";
		str += "p6.name as jobname,pro.project_name,ci.dev_ci_name,ci.dev_ci_model, ";
		str += "appdet.apply_num,appdet.teamid,appdet.team, ";
		str += "appdet.purpose,appdet.employee_id,emp.employee_name, ";
		str += "appdet.plan_start_date,appdet.plan_end_date  ";
		str += "from gms_device_disapp_detail appdet ";
		str += "left join gms_device_disapp devapp on appdet.device_app_id = devapp.device_app_id ";
		str += "left join bgp_p6_activity p6 on appdet.teamid = p6.object_id ";
		str += "left join comm_coding_sort_detail teamsd on appdet.team = teamsd.coding_code_id ";
		str += "left join comm_coding_sort_detail sd on appdet.unitinfo = sd.coding_code_id ";
		str += "left join gp_task_project pro on appdet.project_info_no = pro.project_info_no ";
		str += "left join gms_device_codeinfo ci on appdet.dev_ci_code = ci.dev_ci_code ";
		str += "left join comm_human_employee emp on appdet.employee_id = emp.employee_id ";
		str += "where devapp.device_app_id = '"+idinfo+"' and appdet.bsflag='0' ";
		str += "and devapp.bsflag = '0' ";
		var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+str);
		retObj = queryRet.datas;
		if(retObj!=undefined&&retObj.length>0){
			for(var index=0;index<retObj.length;index++){
				var innerhtml = "<tr id='tr"+retObj[index].dev_acc_id+"' name='tr' >";
				innerhtml += "<td>"+(index+1)+"</td>";
				innerhtml += "<td>"+retObj[index].teamname+"</td>";
				innerhtml += "<td>"+retObj[index].dev_ci_name+"</td>";
				innerhtml += "<td>"+retObj[index].dev_ci_model+"</td>";
				innerhtml += "<td>"+retObj[index].unitname+"</td>";
				innerhtml += "<td>"+retObj[index].apply_num+"</td>";
				innerhtml += "<td>"+retObj[index].employee_name+"</td>";
				innerhtml += "<td>"+retObj[index].purpose+"</td>";
				innerhtml += "<td>"+retObj[index].plan_start_date+"</td>";
				innerhtml += "<td>"+retObj[index].plan_end_date+"</td>";
				innerhtml += "</tr>";
				$("#detlist").append(innerhtml);
			}
			//样式
			$("#detlist>tr:odd>td:odd").addClass("odd_odd");
			$("#detlist>tr:odd>td:even").addClass("odd_even");
			$("#detlist>tr:even>td:odd").addClass("even_odd");
			$("#detlist>tr:even>td:even").addClass("even_even");
		}
	}
	function submitInfo(oprinfo){
		var oprstate;
		if(oprinfo==1){
			oprstate = "pass";
		}else{
			oprstate = "notPass";
		}
		var leaderinfo = document.getElementById("leaderinfo").value;
		if(leaderinfo == ""){
			alert("请填写意见项!");
			return;
		}
		document.getElementById("isPass").value=oprstate;
		document.getElementById("form1").action = "<%=contextPath%>/rm/dm/toSaveDisAppModifyInfowfpa.srq?oprstate="+oprstate;;
		document.getElementById("form1").submit();
	}
</script>
<script type="text/javascript">	
	var selectedTagIndex = 0;
	var showTabBox = document.getElementById("tab_box_content0");

	//打开新增界面
	function toAddPage(){
		popWindow('<%=contextPath%>/rm/dm/devdis/disdetail_new_apply.jsp?projectInfoNo=<%=projectInfoNo%>&deviceappid=<%=deviceappid%>','950:680');
	}
	//打开修改界面
	function toModifyPage(){
		var count=0;
		var selectedid = "";
		$("input[type='checkbox'][name='selectedbox']").each(function(){
			if(this.checked){
				count++;
				selectedid = this.value;
			}
		});
		if(count < 1){
			alert("请选择一条记录！");
			return;
		}
		popWindow('<%=contextPath%>/rm/dm/devdis/disdetail_modify_apply.jsp?projectInfoNo=<%=projectInfoNo%>&deviceappid=<%=deviceappid%>&deviceappdetid='+selectedid,'950:680');
	}
	function dbclickRow(shuaId){
		//判断状态
		var querySql = "select devapp.device_app_id,nvl(wfmiddle.proc_status,'') as proc_status ";
		querySql += "from gms_device_disapp devapp left join common_busi_wf_middle wfmiddle on devapp.device_allapp_id=wfmiddle.business_id ";
		querySql += "where devapp.bsflag='0' and devapp.device_app_id='<%=deviceappid%>' ";
		var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql);
		var basedatas = queryRet.datas;
		if(basedatas.length>=1 && (basedatas[0].proc_status == '0'||basedatas[0].proc_status == '3')){
			return;
		}
		popWindow('<%=contextPath%>/rm/dm/devdis/disdetail_modify_apply.jsp?projectInfoNo=<%=projectInfoNo%>&deviceappid=<%=deviceappid%>&deviceappdetid='+shuaId,'950:680');
	}
	function toDelRecord(){
		var count = 0;
		var selectedid = "";
		$("input[type='checkbox'][name='selectedbox']").each(function(){
			if(this.checked){
				if(count == 0){
					selectedid = "'"+this.value+"'";
				}else{
					selectedid += ",'"+this.value+"'";
				}
				count++;
			}
		});
		
		if(count < 1){
			alert("请选择记录！");
			return;
		}
		if(confirm("一共选择了"+count+"条记录，是否执行删除？")){
			var sql = "update gms_device_disapp_detail set bsflag='1' where device_app_detid in ("+selectedid+")";
			var path = cruConfig.contextPath+"/rad/asyncDelete.srq";
			var params = "deleteSql="+sql;
			params += "&ids=";
			var retObject = syncRequest('Post',path,params);
			refreshData();
		}
	}
    //chooseOne()函式，參數為觸發該函式的元素本身   
    function chooseOne(cb){   
        //先取得同name的chekcBox的集合物件   
        var obj = document.getElementsByName("rdo_entity_id");   
        for (i=0; i<obj.length; i++){   
            //判斷obj集合中的i元素是否為cb，若否則表示未被點選   
            if (obj[i]!=cb) obj[i].checked = false;   
            //若是 但原先未被勾選 則變成勾選；反之 則變為未勾選   
            //else  obj[i].checked = cb.checked;   
            //若要至少勾選一個的話，則把上面那行else拿掉，換用下面那行   
            else obj[i].checked = true;   
        }   
    }   

    function loadDataDetail(device_app_detid){
    	var retObj;
    	var deviceappdetid;
		if(device_app_detid!=null){
			deviceappdetid = device_app_detid;
		}else{
			var ids = getSelIds('selectedbox');
		    if(ids==''){ 
			    alert("请先选中一条记录!");
	     		return;
		    }
		    deviceappdetid = ids;
		}
		
    	var str = "select appdet.device_app_detid,appdet.project_info_no,sd.coding_name as unitname,teamsd.coding_name as teamname, p6.name as jobname, ";
		str += "pro.project_name,ci.dev_ci_name,ci.dev_ci_model, ";
		str += "appdet.apply_num,appdet.teamid,appdet.team, ";
		str += "appdet.purpose,appdet.employee_id,emp.employee_name, ";
		str += "appdet.plan_start_date,appdet.plan_end_date  ";
		str += "from gms_device_disapp_detail appdet ";
		str += "left join gms_device_disapp devapp on appdet.device_app_id = devapp.device_app_id ";
		str += "left join bgp_p6_activity p6 on appdet.teamid = p6.object_id ";
		str += "left join comm_coding_sort_detail teamsd on appdet.team = teamsd.coding_code_id ";
		str += "left join comm_coding_sort_detail sd on appdet.unitinfo = sd.coding_code_id ";
		str += "left join gp_task_project pro on appdet.project_info_no = pro.project_info_no ";
		str += "left join gms_device_codeinfo ci on appdet.dev_ci_code = ci.dev_ci_code ";
		str += "left join comm_human_employee emp on appdet.employee_id = emp.employee_id ";
		str += "where devapp.device_app_id = '"+idinfo+"' and appdet.bsflag='0' ";
		str += "and appdet.device_app_detid= '"+deviceappdetid+"' and devapp.bsflag = '0' ";
		
		var unitRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+str);
		retObj = unitRet.datas;
		
		$("#project_name","#detailMap").val(retObj[0].project_name);
		$("#team","#detailMap").val(retObj[0].teamname);
		$("#purpose","#detailMap").val(retObj[0].purpose);
		$("#dev_ci_name","#detailMap").val(retObj[0].dev_ci_name);
		$("#dev_ci_model","#detailMap").val(retObj[0].dev_ci_model);
		$("#apply_num","#detailMap").val(retObj[0].apply_num);
		$("#unitname","#detailMap").val(retObj[0].unitname);
		$("#plan_start_date","#detailMap").val(retObj[0].plan_start_date);
		$("#plan_end_date","#detailMap").val(retObj[0].plan_end_date);
		//重新加载当前标签页信息
		getContentTab(undefined,selectedTagIndex);
    }
	
</script>
</html>
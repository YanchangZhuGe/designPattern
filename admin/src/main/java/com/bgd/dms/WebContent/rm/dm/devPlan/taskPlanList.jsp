<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@ page import="java.util.*"%>
<%@ page import="com.cnpc.jcdp.soa.msg.MsgElement"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String taskId = request.getParameter("taskObjectId");
	String taskName = request.getParameter("taskName");
	taskName = java.net.URLDecoder.decode(taskName, "utf-8");
	String projectInfoNo = request.getParameter("projectInfoNo");
	String idinfo = request.getParameter("idinfo");
	
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
<link href="<%=contextPath%>/css/calendar-blue.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/JavaScript" src="<%=contextPath%>/js/calendar-zh.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open2.js"></script>

  <title>项目页面</title> 
 </head> 
 
 <body style="background:#fff" onload="refreshData()">
      	<div id="list_table">
			<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			  	<td class="ali_cdn_name">设备名称</td>
			    <td class="ali_cdn_input">
			    	<input id="s_dev_ci_name" name="s_dev_ci_name" type="text" class="input_width" />
			    </td>
			    <td class="ali_cdn_name">排序规则</td>
			    <td class="ali_cdn_input">
			    	<select id="s_order_info" name="s_order_info" type="text" class="select_width" >
			    		<option id="teaminfo" name="teaminfo" value="team">按班组</option>  
			    		<option id="devinfo" name="devinfo" value="dev_ci_code"> 按设备名称</option>
			    	</select>
			    </td>
			    <td class="ali_query">
			    	<span class="cx"><a href="#" onclick="searchDevData()" title="查询"></a></span>
			    </td>
			    <td class="ali_query">
				    <span class="qc"><a href="#" onclick="clearQueryText()" title="清除"></a></span>
			    </td>
			    <td>&nbsp;</td>
			    <auth:ListButton functionId="" css="zj" event="onclick='toAddPage()'" title="添加"></auth:ListButton>
			    <auth:ListButton functionId="" css="xg" event="onclick='toModifyPage()'" title="修改"></auth:ListButton>
			    <auth:ListButton functionId="" css="sc" event="onclick='toDelRecord()'" title="删除"></auth:ListButton>
			    <auth:ListButton functionId="" css="dc" event="onclick='exportData()'" title="导出excel"></auth:ListButton>
			    <% if(idinfo!=null&&!"".equals(idinfo)&&!"null".equals(idinfo)){ %>
			    	<auth:ListButton functionId="" css="fh" event="onclick='toBack()'" title="返回"></auth:ListButton>
			    <% }%>
			  </tr>
			</table>
			</td>
			    <td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
			  </tr>
			</table>
			</div>
			<div id="table_box">
			  <table style="width:98%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">		
			    <tr id='device_appdet_id_{device_allapp_detid}' name='device_allapp_detid'>
					<td class="bt_info_even" exp="<input type='checkbox' name='selectedbox' value='{device_allapp_detid}~{seqinfo}' id='selectedbox_{device_allapp_detid}' onclick='chooseOne(this)'/>" >选择</td>
					<td class="bt_info_odd" exp="{jobname}" isExport='Hide'>工序</td>
					<td class="bt_info_even" exp="{teamname}">班组</td>
					<td class="bt_info_odd" exp="{dev_ci_name}">设备名称</td>
					<td class="bt_info_even" exp="{dev_ci_model}">规格型号</td>
					<td class="bt_info_odd" exp="{unitname}">单位</td>
					<td class="bt_info_even" exp="{apply_num}">需求数量</td>
					<td class="bt_info_odd" exp="{purpose}">备注</td>
					<td class="bt_info_even" exp="{plan_start_date}">计划开始时间</td>
					<td class="bt_info_odd" exp="{plan_end_date}">计划结束时间</td>
					<td class="bt_info_even" exp="{managetype}" isExport='Hide'>设备管理类别</td>
			     </tr> 
			  </table>
			</div>
			<div id="fenye_box"  style="display:block"><table width="100%" border="0" cellspacing="0" cellpadding="0" id="fenye_box_table">
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
			    <li class="selectTag" id="tag3_0" ><a href="#" onclick="getContentTab(this,0)">基本信息</a></li>
			    <li id="tag3_1"><a href="#" onclick="getContentTab(this,3)">附件</a></li>
			    <li id="tag3_1"><a href="#" onclick="getContentTab(this,4)">备注</a></li>
			    <li id="tag3_1"><a href="#" onclick="getContentTab(this,5)">分类码</a></li>
			  </ul>
			</div>
			<div id="tab_box" class="tab_box">
				<div id="tab_box_content0" name="tab_box_content0" class="tab_box_content">
					<table id="detailMap" name="detailMap" border="0" cellpadding="0" cellspacing="0"  class="tab_line_height" width="100%" style="margin-top:10px;background:#efefef"> 
					<tr>
				      <td  class="inquire_item6">项目名称：</td>
				      <td  class="inquire_form6" ><input id="project_name" class="input_width" type="text" value="" disabled/>&nbsp;</td>
				      <td  class="inquire_item6">班组：</td>
				      <td  class="inquire_form6"><input id="team" class="input_width" type="text"  value="" disabled/> &nbsp;</td>
				      <td  class="inquire_item6">&nbsp;用途：</td>
				      <td  class="inquire_form6"  ><input id="purpose" class="input_width" type="text"  value="" disabled/> &nbsp;</td>
				     </tr>
				    <tr >
				     <td  class="inquire_item6">设备名称：</td>
				     <td  class="inquire_form6"><input id="dev_ci_name" class="input_width" type="text"  value="" disabled/> &nbsp;</td> 
				     <td  class="inquire_item6">&nbsp;规格型号：</td>
				     <td  class="inquire_form6"><input id="dev_ci_model" class="input_width" type="text"  value="" disabled/> &nbsp;</td>  
				     <td  class="inquire_item6">需求数量：</td>
				     <td  class="inquire_form6"><input id="apply_num" class="input_width" type="text"  value="" disabled/> &nbsp;</td> 
				    </tr>
				    <tr>
				     <td  class="inquire_item6">单位：</td>
				     <td  class="inquire_form6"><input id="unitname" class="input_width" type="text"  value="" disabled/> &nbsp;</td> 
				     <td  class="inquire_item6">&nbsp;计划开始时间：</td>
				     <td  class="inquire_form6"><input id="plan_start_date" class="input_width" type="text"  value="" disabled/> &nbsp;</td> 
				     <td  class="inquire_item6">&nbsp;计划结束时间：</td>
				     <td  class="inquire_form6"><input id="plan_end_date" class="input_width" type="text"  value="" disabled/> &nbsp;</td>
				     <td colspan='2'>&nbsp;</td>
				    </tr>
					</table>
				</div>
			<div id="tab_box_content3" name="tab_box_content3" class="tab_box_content" style="display:none;">
				<iframe width="100%" height="100%" name="attachement" id="attachement" frameborder="0" src="" marginheight="0" marginwidth="0" ></iframe>
			</div>
			<div id="tab_box_content4" name="tab_box_content4" class="tab_box_content" style="display:none;">
				<iframe width="100%" height="100%" name="remark" id="remark" frameborder="0" src="" marginheight="0" marginwidth="0" ></iframe>
			</div>
			<div id="tab_box_content5" name="tab_box_content5" class="tab_box_content" style="display:none;">
				<iframe width="100%" height="100%" name="codeManager" id="codeManager" frameborder="0" src="" marginheight="0" marginwidth="0"  scrolling="auto" style="overflow: scroll;"></iframe>
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
function getContentTab(obj,index) { 
		$("LI","#tag-container_3").removeClass("selectTag");
		var contentSelectedTag = obj.parentElement;
		contentSelectedTag.className ="selectTag";

		var filterobj = ".tab_box_content[name=tab_box_content"+index+"]";
		var filternotobj = ".tab_box_content[name!=tab_box_content"+index+"]";
		$(filternotobj).hide();
		$(filterobj).show();
	}

$(document).ready(lashen);

$().ready(function(){
	var str = "select devapp.device_allapp_id,nvl(wfmiddle.proc_status,'') as proc_status ";
		str += "from gms_device_allapp devapp  ";
		str += "left join common_busi_wf_middle wfmiddle on wfmiddle.business_id = devapp.device_allapp_id  ";
	if('<%=idinfo%>'==null||'<%=idinfo%>'=='null'){
		str += "where devapp.project_info_no = '<%=projectInfoNo%>' and devapp.bsflag='0' ";
	}else{
		str += "where devapp.device_allapp_id = '<%=idinfo%>' ";
	}
	var unitRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+str);
	var stateObj = unitRet.datas;
	if(stateObj.length>=1 && (stateObj[0].proc_status == '0'||stateObj[0].proc_status == '3')){
		$(".zj").hide();
		$(".xg").hide();
		$(".sc").hide();
	}
});

</script>
 
<script type="text/javascript">

	cruConfig.contextPath =  "<%=contextPath%>";
	cruConfig.cdtType = 'form';
	var taskIds = '<%=taskId%>';
	var projectInfoNos = '<%=projectInfoNo%>';
	var idinfo = '<%=idinfo%>';
	
	function clearQueryText(){
		document.getElementById("s_dev_ci_name").value = "";
		document.getElementById("s_dev_ci_model").value = "";
	}
	
	function searchDevData(){
		var v_dev_ci_name = document.getElementById("s_dev_ci_name").value;
		var v_order_info = $("#s_order_info option:selected").val();
		//var v_dev_ci_model = document.getElementById("s_dev_ci_model").value;
		refreshData(v_dev_ci_name, v_order_info);
	}
	
	function refreshData(v_dev_ci_name,v_order_info){
		var str = "select * from ("
		str += "select alldet.device_allapp_detid,alldet.project_info_no,sd.coding_name as unitname,teamsd.coding_name as teamname, ";
		str += "alldet.dev_ci_code,p6.name as jobname,pro.project_name,";
		str += "case when alldet.dev_name is null then (case when alldet.isdevicecode = 'N' then ci.dev_ci_name else ct.dev_ct_name end) else alldet.dev_name end as dev_ci_name,";
		str += "case when alldet.dev_type is null then (case when alldet.isdevicecode='N' then ci.dev_ci_model else '' end) else alldet.dev_type end as dev_ci_model, ";
		str += "alldet.apply_num,alldet.teamid,alldet.team, ";
		str += "alldet.purpose,alldet.employee_id,emp.employee_name, ";
		str += "alldet.plan_start_date,alldet.plan_end_date,'单台管理' as managetype,'0' as seqinfo  ";
		str += "from gms_device_allapp_detail alldet ";
		str += "left join gms_device_allapp devapp on alldet.device_allapp_id = devapp.device_allapp_id ";
		str += "left join bgp_p6_activity p6 on alldet.teamid = p6.object_id ";
		str += "left join comm_coding_sort_detail teamsd on alldet.team = teamsd.coding_code_id ";
		str += "left join comm_coding_sort_detail sd on alldet.unitinfo = sd.coding_code_id ";
		str += "left join gp_task_project pro on alldet.project_info_no = pro.project_info_no ";
		str += "left join gms_device_codeinfo ci on alldet.dev_ci_code = ci.dev_ci_code ";
		str += "left join gms_device_codetype ct on alldet.dev_ci_code = ct.dev_ct_code ";
		str += "left join comm_human_employee emp on alldet.employee_id = emp.employee_id ";
		if(idinfo==null||idinfo=='null'){
			str += "where devapp.project_info_no = '<%=projectInfoNo%>' and devapp.bsflag = '0' ";
		}else{
			str += "where devapp.device_allapp_id = '<%=idinfo%>' and alldet.bsflag='0' ";
		}
		str += "and alldet.bsflag='0' and alldet.teamid='"+taskIds+"'";
		if(v_dev_ci_name!=undefined && v_dev_ci_name!=''){
			str += "and ci.dev_ci_name like '"+v_dev_ci_name+"%' ";
		}
		str += "union "
		str += "select alldet.device_allapp_detid,alldet.project_info_no,sd.coding_name as unitname,teamsd.coding_name as teamname, ";
		str += "'' as dev_ci_code,p6.name as jobname,pro.project_name,alldet.dev_name_input as dev_ci_name,devtype.coding_name as dev_ci_model, ";
		str += "alldet.apply_num,alldet.teamid,alldet.team, ";
		str += "alldet.purpose,alldet.employee_id,emp.employee_name, ";
		str += "alldet.plan_start_date,alldet.plan_end_date,'批量管理' as managetype,'1' as seqinfo  ";
		str += "from gms_device_allapp_colldetail alldet ";
		str += "left join gms_device_allapp devapp on alldet.device_allapp_id = devapp.device_allapp_id ";
		str += "left join bgp_p6_activity p6 on alldet.teamid = p6.object_id ";
		str += "left join comm_coding_sort_detail devtype on alldet.dev_codetype = devtype.coding_code_id ";
		str += "left join comm_coding_sort_detail teamsd on alldet.team = teamsd.coding_code_id ";
		str += "left join comm_coding_sort_detail sd on alldet.unitinfo = sd.coding_code_id ";
		str += "left join gp_task_project pro on alldet.project_info_no = pro.project_info_no ";
		str += "left join comm_human_employee emp on alldet.employee_id = emp.employee_id ";
		if(idinfo==null||idinfo=='null'){
			str += "where devapp.project_info_no = '<%=projectInfoNo%>' and devapp.bsflag = '0' ";
		}else{
			str += "where devapp.device_allapp_id = '<%=idinfo%>' and alldet.bsflag='0' ";
		}
		str += "and alldet.bsflag='0' and alldet.teamid='"+taskIds+"'";
		if(v_dev_ci_name!=undefined && v_dev_ci_name!=''){
			str += "and alldet.dev_name_input like '%"+v_dev_ci_name+"%' ";
		}
		str += ") order by seqinfo ";
		if(v_order_info!=undefined && v_order_info!=''){
			str += ","+v_order_info;
		}else{
			str += ",team";
		}
		
		cruConfig.queryStr = str;
		queryData(cruConfig.currentPage);
		createNewTitleTable();
	}

	//打开新增界面
	function getQueryString(name) {
	    var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)", "i");
	    var r = window.location.search.substr(1).match(reg);
	    if (r != null) return unescape(r[2]);
	    return null;
	    }
    var taskName = getQueryString("taskName");
	function toAddPage(){
		popWindow('<%=contextPath%>/rm/dm/devPlan/devdetail_new_apply.jsp?projectInfoNo=<%=projectInfoNo%>&taskId=<%=taskId%>&deviceallappid=<%=idinfo%>&taskName=<%=taskName%>','900:680');
	}
	//打开修改界面
	function toModifyPage(){
		var length = 0;
		$("input[type='checkbox'][name='selectedbox']").each(function(i){
			if(this.checked == true){
				length = length+1;
			}
		});
		if(length!=1){
			alert("请选择一条记录！");
			return;
		}
		var selectedid = null;
		$("input[type='checkbox'][name='selectedbox']").each(function(i){
			if(this.checked == true){
				selectedid = this.value;
			}
		});
		popWindow('<%=contextPath%>/rm/dm/devPlan/devdetail_modify_apply.jsp?deviceallappid=<%=idinfo%>&deviceallappdetid='+selectedid,'900:680');
	}
	
	function toDelRecord(){
		var length = 0;
		$("input[type='checkbox'][name='selectedbox']").each(function(i){
			if(this.checked == true){
				length = length+1;
			}
		});
		if(length == 0){
			alert("请选择一条记录！");
			return;
		}
		if(confirm("一共选择了"+length+"条记录，是否执行删除？")){
			var selectedid = "";
			var checkindex = 0;
			$("input[type='checkbox'][name='selectedbox']").each(function(i){
				if(this.checked == true){
					if(checkindex!=0){
						selectedid += ",";
					}
					selectedid += "'"+this.value.split("~",-1)[0]+"'";
					checkindex ++;
				}
			});
			var sql="";
			var getsql = "select * from gms_device_allapp_detail t where t.device_allapp_detid in ("+selectedid+")";
			var retDatas = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+getsql);
			if(retDatas.datas != ""){
				sql = "update gms_device_allapp_detail set bsflag='1' where device_allapp_detid in ("+selectedid+")";
			}
			else{
				sql = "update gms_device_allapp_colldetail set bsflag='1' where device_allapp_detid in ("+selectedid+")";
				}
			var path = cruConfig.contextPath+"/rad/asyncDelete.srq";
			var params = "deleteSql="+sql;
			params += "&ids=";
			var retObject = syncRequest('Post',path,params);
			refreshData();
		}
	}
	
    function chooseOne(cb){   
        var obj = document.getElementsByName("rdo_entity_id");   
        for (i=0; i<obj.length; i++){   
            if (obj[i]!=cb) obj[i].checked = false;   
            else obj[i].checked = true;   
        }   
    }   

    function loadDataDetail(device_allapp_detid){
    	var retObj;
    	var deviceallappdetid;
		if(device_allapp_detid!=null){
			deviceallappdetid = device_allapp_detid;
		}else{
			var ids = getSelIds('selectedbox');
		    if(ids==''){ 
			    alert("请先选中一条记录!");
	     		return;
		    }
		    deviceallappdetid = ids;
		}
		
		deviceallappdetid = deviceallappdetid.substr(0,deviceallappdetid.length-2);
		
    	var str = "select alldet.device_allapp_detid,alldet.project_info_no,sd.coding_name as unitname, ";
		str += "pro.project_name, ";
		str += "case when alldet.dev_name is null then (case when alldet.isdevicecode = 'N' then ci.dev_ci_name else ct.dev_ct_name end) else alldet.dev_name end as dev_ci_name,";
		str += "case when alldet.dev_type is null then (case when alldet.isdevicecode='N' then ci.dev_ci_model else '' end) else alldet.dev_type end as dev_ci_model, ";
		str += "alldet.apply_num,alldet.teamid,teamsd.coding_name as teamname, ";
		str += "alldet.purpose,alldet.employee_id,emp.employee_name, ";
		str += "alldet.plan_start_date,alldet.plan_end_date  ";
		str += "from gms_device_allapp_detail alldet ";
		str += "left join gms_device_allapp devapp on alldet.device_allapp_id = devapp.device_allapp_id ";
		str += "left join comm_coding_sort_detail teamsd on alldet.team = teamsd.coding_code_id ";
		str += "left join comm_coding_sort_detail sd on alldet.unitinfo = sd.coding_code_id ";
		str += "left join gp_task_project pro on alldet.project_info_no = pro.project_info_no ";
		str += "left join gms_device_codeinfo ci on alldet.dev_ci_code = ci.dev_ci_code ";
		str += "left join gms_device_codetype ct on alldet.dev_ci_code = ct.dev_ct_code ";
		str += "left join comm_human_employee emp on alldet.employee_id = emp.employee_id ";
		str += "where alldet.device_allapp_detid = '"+deviceallappdetid+"' and alldet.teamid='"+taskIds+"'";
		str += "and devapp.bsflag = '0' ";
		str += "union ";
		str += "select alldet.device_allapp_detid,alldet.project_info_no,sd.coding_name as unitname,";
		str += "pro.project_name,alldet.dev_name_input as dev_ci_name,devtype.coding_name as dev_ci_model, ";
		str += "alldet.apply_num,alldet.teamid,teamsd.coding_name as teamname, ";
		str += "alldet.purpose,alldet.employee_id,emp.employee_name, ";
		str += "alldet.plan_start_date,alldet.plan_end_date ";
		str += "from gms_device_allapp_colldetail alldet ";
		str += "left join gms_device_allapp devapp on alldet.device_allapp_id = devapp.device_allapp_id ";
		str += "left join comm_coding_sort_detail teamsd on alldet.team = teamsd.coding_code_id ";
		str += "left join bgp_p6_activity p6 on alldet.teamid = p6.object_id ";
		str += "left join comm_coding_sort_detail devtype on alldet.dev_codetype = devtype.coding_code_id ";
		str += "left join comm_coding_sort_detail sd on alldet.unitinfo = sd.coding_code_id ";
		str += "left join gp_task_project pro on alldet.project_info_no = pro.project_info_no ";
		str += "left join comm_human_employee emp on alldet.employee_id = emp.employee_id ";
		str += "where alldet.device_allapp_detid = '"+deviceallappdetid+"' and alldet.teamid='"+taskIds+"'";
		str += "and devapp.bsflag = '0' ";
		
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
    }
    function toBack(){
		window.parent.location.href='<%=contextPath%>/rm/dm/devPlan/planMainInfoList.jsp';
		}
    function createNewTitleTable(){
		// 如果是dialog
		if(window.dialogArguments){
			return;
		}
		
		// 如果声明了不出现固定表头
		if(window.showNewTitle==false){
			return;
		}
		
		var newTitleTable = document.getElementById("newTitleTable");
		if(newTitleTable!=null) return;
		var queryRetTable = document.getElementById("queryRetTable");
		if(queryRetTable==null) return;
		var titleRow = queryRetTable.rows(0);
		
		var newTitleTable = document.createElement("table");
		newTitleTable.id = "newTitleTable";
		newTitleTable.className="tab_info";
		newTitleTable.border="0";
		newTitleTable.cellSpacing="0";
		newTitleTable.cellPadding="0";
		newTitleTable.style.width = queryRetTable.clientWidth;
		newTitleTable.style.position="absolute";
		var x = getAbsLeft(queryRetTable);
		newTitleTable.style.left=x+"px";
		var y = getAbsTop(queryRetTable)-4;
		newTitleTable.style.top=y+"px";
		
		
		var tbody = document.createElement("tbody");
		var tr = titleRow.cloneNode(true);
		
		tbody.appendChild(tr);
		newTitleTable.appendChild(tbody);
		document.body.appendChild(newTitleTable);
		// 设置每一列的宽度
		for(var i=0;i<tr.cells.length;i++){
			tr.cells[i].style.width=titleRow.cells[i].clientWidth;
			if(i%2==0){
				tr.cells[i].className="bt_info_odd";
			}else{
				tr.cells[i].className="bt_info_even";
			}
			// 设置是否显示
			if(titleRow.cells[i].isShow=="Hide"){
				tr.cells[i].style.display='none';
			}
		}
		
		document.getElementById("table_box").onscroll = resetNewTitleTablePos;
		
	}
</script>
</html>
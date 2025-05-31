<%@ page contentType="text/html;charset=utf-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%@taglib uri="wf" prefix="wf"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String projectInfoNo = request.getParameter("projectInfoNo");
	String devicehireappid = request.getParameter("devicehireappid");
	String sonFlag = request.getParameter("sonFlag");
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

  <title>单项目-调配申请-调配申请(外租设备)-编辑明细页面</title> 
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
			    <td class="ali_cdn_name">规格型号</td>
			    <td class="ali_cdn_input">
			    	<input id="s_dev_ci_model" name="s_dev_ci_model" type="text" class="input_width" />
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
			    <auth:ListButton functionId="" css="fh" event="onclick='javascript:window.history.back();'" title="返回"></auth:ListButton>
			  </tr>
			</table>
			</td>
			    <td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
			  </tr>
			</table>
			</div>
			<div id="table_box">
			  <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">		
			     <tr id='device_appdet_id_{device_app_detid}' name='device_app_detid'>
			     	<td class="bt_info_odd" exp="<input type='checkbox' name='selectedbox' value='{device_app_detid}' id='selectedbox_{device_app_detid}' onclick='chooseOne(this)'/>" >选择</td>
					<td class="bt_info_even" autoOrder="1">序号</td>
					<td class="bt_info_odd" exp="{device_hireapp_name}">外租申请单名称</td>
					<td class="bt_info_even" exp="{jobname}">工序</td>
					<td class="bt_info_odd" exp="{teamname}">班组</td>
					<td class="bt_info_even" exp="{dev_ci_name}">设备名称</td>
					<td class="bt_info_odd" exp="{dev_ci_model}">规格型号</td>
					<td class="bt_info_even" exp="{unitname}">单位</td>
					<td class="bt_info_odd" exp="{apply_num}">申请数量</td>
					<td class="bt_info_even" exp="{employee_name}">申请人</td>
					<td class="bt_info_odd" exp="{plan_start_date}">计划开始时间</td>
					<td class="bt_info_even" exp="{plan_end_date}">计划结束时间</td>
					<td class="bt_info_odd" exp="{devrental}">预计租赁费</td>
					<td class="bt_info_even" exp="{rentname}">出租方单位名称</td>
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
				<div id="tab_box_content0" class="tab_box_content">
					<table id="detailMap" name="detailMap" border="0" cellpadding="0" cellspacing="0"  class="tab_line_height" width="100%" style="margin-top:10px;background:#efefef"> 
					<tr>
				      <td  class="inquire_item6">外租申请单名称：</td>
				      <td  class="inquire_form6" ><input id="device_hireapp_name" class="input_width" type="text" value="" disabled/>&nbsp;</td>
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
				     <td  class="inquire_item6">申请数量：</td>
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
				    <tr>
				     <td  class="inquire_item6">预计租赁费：</td>
				     <td  class="inquire_form6"><input id="devrental" class="input_width" type="text"  value="" disabled/> &nbsp;</td> 
				     <td  class="inquire_item6">&nbsp;出租方单位名称：</td>
				     <td  class="inquire_form6"><input id="rentname" class="input_width" type="text"  value="" disabled/> &nbsp;</td> 
				     <td  class="inquire_item6"></td>
				     <td  class="inquire_form6"></td>
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
$(document).ready(lashen);

var sonFlag_tmp="<%=sonFlag%>";

$().ready(function(){
	//判断状态
	var querySql = "select devapp.device_hireapp_id,nvl(wfmiddle.proc_status,'') as proc_status ";
	querySql += "from gms_device_hireapp devapp left join common_busi_wf_middle wfmiddle on devapp.device_hireapp_id=wfmiddle.business_id ";
	querySql += "where devapp.bsflag='0' and devapp.device_hireapp_id ='<%=devicehireappid%>'";
	var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql);
	var basedatas = queryRet.datas;
	if((basedatas.length>=1 && (basedatas[0].proc_status == '0'||basedatas[0].proc_status == '3'))||sonFlag_tmp == 'Y'){
		$(".zj").hide();
		$(".xg").hide();
		$(".sc").hide();
	}
});

</script>
 
<script type="text/javascript">

	cruConfig.contextPath =  "<%=contextPath%>";
	cruConfig.cdtType = 'form';
	var projectInfoNos = '<%=projectInfoNo%>';
	var idinfo = '<%=devicehireappid%>';

	function searchDevData(){
		var v_dev_ci_name = document.getElementById("s_dev_ci_name").value;
		var v_dev_ci_model = document.getElementById("s_dev_ci_model").value;
		refreshData(v_dev_ci_name, v_dev_ci_model);
	}
	
	function refreshData(v_dev_ci_name,v_dev_ci_model){
	
		var str = "select appdet.device_app_detid,appdet.project_info_no,sd.coding_name as unitname,teamsd.coding_name as teamname, ";
		str += "p6.name as jobname,pro.project_name,devapp.device_hireapp_name,";
		str += "appdet.dev_name as dev_ci_name,";
		str += "appdet.dev_type as dev_ci_model, ";
		str += "appdet.apply_num,appdet.teamid,appdet.team, ";
		str += "appdet.purpose,appdet.employee_id,emp.employee_name, ";
		str += "appdet.plan_start_date,appdet.plan_end_date,appdet.devrental,appdet.rentname  ";
		str += "from gms_device_hireapp_detail appdet ";
		str += "left join gms_device_hireapp devapp on appdet.device_hireapp_id = devapp.device_hireapp_id ";
		str += "left join bgp_p6_activity p6 on appdet.teamid = p6.object_id ";
		str += "left join comm_coding_sort_detail teamsd on appdet.team = teamsd.coding_code_id ";
		str += "left join comm_coding_sort_detail sd on appdet.unitinfo = sd.coding_code_id ";
		str += "left join gp_task_project pro on appdet.project_info_no = pro.project_info_no ";
		str += "left join gms_device_codeinfo ci on appdet.dev_ci_code = ci.dev_ci_code ";
		str += "left join gms_device_codetype ct on appdet.dev_ci_code = ct.dev_ct_code ";
		str += "left join comm_human_employee emp on appdet.employee_id = emp.employee_id ";
		str += "where devapp.device_hireapp_id = '"+idinfo+"' ";
		str += "and devapp.bsflag = '0' and appdet.bsflag='0'";
		if(v_dev_ci_name!=undefined && v_dev_ci_name!=''){
			str += "and ci.dev_ci_name like '"+v_dev_ci_name+"%' ";
		}
		if(v_dev_ci_model!=undefined && v_dev_ci_model!=''){
			str += "and ci.dev_ci_model like '"+v_dev_ci_model+"%' ";
		}
		cruConfig.queryStr = str;
		queryData(cruConfig.currentPage);;
		
	}
</script>
<script type="text/javascript">	
	var selectedTagIndex = 0;
	var showTabBox = document.getElementById("tab_box_content0");

	//打开新增界面
	function toAddPage(){
		popWindow('<%=contextPath%>/rm/dm/hireplan/hiredetail_new_apply.jsp?projectInfoNo=<%=projectInfoNo%>&devicehireappid=<%=devicehireappid%>','1050:680');	}
	//打开修改界面
	function toModifyPage(){
		var length = 0;
		var selectedid ;
		$("input[type='checkbox'][name='selectedbox']").each(function(){
			if(this.checked){
				selectedid = this.value;
				length = length+1;
			}
		});
		if(length!=1){
			alert("请选择一条记录！");
			return;
		}
		popWindow('<%=contextPath%>/rm/dm/hireplan/hiredetail_modify_apply.jsp?projectInfoNo=<%=projectInfoNo%>&devicehireappid=<%=devicehireappid%>&deviceappdetid='+selectedid,'950:680');
	}
	function dbclickRow(shuaId){
		if(sonFlag == 'Y')
		{
			alert('子项目不能修改！');
		}else
		{
			popWindow('<%=contextPath%>/rm/dm/hireplan/hiredetail_modify_apply.jsp?projectInfoNo=<%=projectInfoNo%>&devicehireappid=<%=devicehireappid%>&deviceappdetid='+shuaId,'950:680');
		}		
	}
	function toDelRecord(){
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
		}
		if(confirm("一共选择了"+length+"条记录，是否执行删除？")){
			var sql = "update gms_device_app_detail set bsflag='1' where device_app_detid in ("+selectedid+")";
			var path = cruConfig.contextPath+"/rad/asyncDelete.srq";
			var params = "deleteSql="+sql;
			params += "&ids=";
			var retObject = syncRequest('Post',path,params);
			refreshData();
		}
	}
    function chooseOne(cb){   
        //先取得同name的chekcBox的集合物件   
        var obj = document.getElementsByName("rdo_entity_id");   
        for (i=0; i<obj.length; i++){   
            if (obj[i]!=cb) obj[i].checked = false;   
            else obj[i].checked = true;   
        }   
    }   

    function loadDataDetail(device_hireapp_detid){
    	var retObj;
    	var devicehireappdetid;
		if(device_hireapp_detid!=null){
			devicehireappdetid = device_hireapp_detid;
		}else{
			var ids = getSelIds('selectedbox');
		    if(ids==''){ 
			    alert("请先选中一条记录!");
	     		return;
		    }
		    devicehireappdetid = ids;
		}
		
    	var str = "select appdet.device_app_detid,appdet.project_info_no,sd.coding_name as unitname,teamsd.coding_name as teamname, p6.name as jobname, ";
		str += "pro.project_name,appdet.dev_name as dev_ci_name,appdet.dev_type as dev_ci_model, ";
		str += "appdet.apply_num,appdet.teamid,appdet.team,devapp.device_hireapp_name, ";
		str += "appdet.purpose,appdet.employee_id,emp.employee_name, ";
		str += "appdet.plan_start_date,appdet.plan_end_date,appdet.devrental,appdet.rentname  ";
		str += "from gms_device_hireapp_detail appdet ";
		str += "left join gms_device_hireapp devapp on appdet.device_hireapp_id = devapp.device_hireapp_id ";
		str += "left join bgp_p6_activity p6 on appdet.teamid = p6.object_id ";
		str += "left join comm_coding_sort_detail teamsd on appdet.team = teamsd.coding_code_id ";
		str += "left join comm_coding_sort_detail sd on appdet.unitinfo = sd.coding_code_id ";
		str += "left join gp_task_project pro on appdet.project_info_no = pro.project_info_no ";
		str += "left join gms_device_codeinfo ci on appdet.dev_ci_code = ci.dev_ci_code ";
		str += "left join comm_human_employee emp on appdet.employee_id = emp.employee_id ";
		str += "where devapp.device_hireapp_id = '"+idinfo+"' and appdet.bsflag='0' ";
		str += "and appdet.device_app_detid= '"+devicehireappdetid+"' and devapp.bsflag = '0' ";
		var unitRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+str);
		retObj = unitRet.datas;
		//取消选中框--------------------------------------------------------------------------
		
		//选中这一条checkbox
		$("#selectedbox_"+retObj[0].device_app_detid).attr("checked",'true');
		//取消其他选中的
		$("input[type='checkbox'][name='selectedbox'][id!='selectedbox_"+retObj[0].device_app_detid+"']").removeAttr("checked");
		
		$("#device_hireapp_name","#detailMap").val(retObj[0].device_hireapp_name);
		$("#team","#detailMap").val(retObj[0].teamname);
		$("#purpose","#detailMap").val(retObj[0].purpose);
		$("#dev_ci_name","#detailMap").val(retObj[0].dev_ci_name);
		$("#dev_ci_model","#detailMap").val(retObj[0].dev_ci_model);
		$("#apply_num","#detailMap").val(retObj[0].apply_num);
		$("#unitname","#detailMap").val(retObj[0].unitname);
		$("#plan_start_date","#detailMap").val(retObj[0].plan_start_date);
		$("#plan_end_date","#detailMap").val(retObj[0].plan_end_date);
		$("#devrental","#detailMap").val(retObj[0].devrental);
		$("#rentname","#detailMap").val(retObj[0].rentname);
    }
	
</script>
</html>
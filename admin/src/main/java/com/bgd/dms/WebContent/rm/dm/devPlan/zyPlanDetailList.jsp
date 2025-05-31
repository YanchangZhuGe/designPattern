<%@ page contentType="text/html;charset=utf-8"%>
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
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open1.js"></script>

  <title>已添加的设备调配明细页面</title> 
 </head> 
 
 <body style="background:#cdddef" onload="refreshData()">
 <div id="new_table_box" style="width:98%;">
 	<div id="new_table_box_content" style="width:100%;" >
 	<div id="new_table_box_bg" style="width:95%;">
 	 <fieldset style="margin-left:2px"><legend >基本信息</legend>
      <table border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
        <tr>
          <td class="inquire_item4" >项目名称:</td>
          <td class="inquire_form4" >
          	<input name="project_name" id="project_name" class="input_width" type="text"  value="<%=user.getProjectName() %>" readonly/>
          	<input name="project_info_no" id="project_info_no" class="input_width" type="hidden"  value="" />
          	<input name="deviceappid" id="deviceappid" type="hidden" value="" />
          </td>
           <td class="inquire_item4" >调配申请单号:</td>
          <td class="inquire_form4" >
          	<input name="appinfo_no" id="appinfo_no" class="input_width" type="text"  value="" readonly/>
          </td>
        </tr>
        <tr>
          <td class="inquire_item4" >申请人:</td>
          <td class="inquire_form4" >
          	<input name="appinfo_no" id="appinfo_no" class="input_width" type="text"  value="<%=user.getUserName() %>" readonly/>
          </td>
          <td class="inquire_item4" >申请单位名称:</td>
          <td class="inquire_form4" >
          	<input name="app_org" id="app_org" class="input_width" type="text"  value="<%=user.getOrgName() %>" readonly/>
          </td>
        </tr>
        <tr>
          <td class="inquire_item4" >申请时间:</td>
          <td class="inquire_form4" >
          	<input name="app_date" id="app_date" class="input_width" type="text"  value="" readonly/>
          </td>
         </tr> 
      </table>
      </fieldset>
      	<div id="list_table">
      	<fieldset style="margin-left:2px"><legend>调配明细</legend>
			<div id="table_box">
			  <table style="width:98.5%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">		
			     <tr id='device_appdet_id_{device_app_detid}' name='device_app_detid'>
					<td class="bt_info_even" autoOrder="1">序号</td>
					<td class="bt_info_odd" exp="{device_app_name}">调配申请单名称</td>
					<td class="bt_info_even" exp="{jobname}">工序</td>
					<td class="bt_info_odd" exp="{teamname}">班组</td>
					<td class="bt_info_even" exp="{dev_ci_name}">设备名称</td>
					<td class="bt_info_odd" exp="{dev_ci_model}">规格型号</td>
					<td class="bt_info_even" exp="{unitname}">单位</td>
					<td class="bt_info_odd" exp="{apply_num}">申请数量</td>
					<td class="bt_info_even" exp="{employee_name}">申请人</td>
					<td class="bt_info_odd" exp="{plan_start_date}">计划开始时间</td>
					<td class="bt_info_even" exp="{plan_end_date}">计划结束时间</td>
					<td class="bt_info_odd" exp="{purpose}">备注</td>
			     </tr> 
			  </table>
			</div>
			</fieldset>
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
	    </div>
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
$(document).ready(lashen);

$().ready(function(){
	//判断状态
	var querySql = "select devapp.device_app_id,nvl(wfmiddle.proc_status,'') as proc_status ";
	querySql += "from gms_device_app devapp left join common_busi_wf_middle wfmiddle on devapp.device_app_id=wfmiddle.business_id ";
	querySql += "where devapp.bsflag='0' and devapp.device_app_id='<%=deviceappid%>' ";
	var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql);
	var basedatas = queryRet.datas;
	if(basedatas.length>=1 && (basedatas[0].proc_status == '0'||basedatas[0].proc_status == '3'||basedatas[0].proc_status == '1')){
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
	var idinfo = '<%=deviceappid%>';

	function searchDevData(){
		var v_dev_ci_name = document.getElementById("s_dev_ci_name").value;
		var v_dev_ci_model = document.getElementById("s_dev_ci_model").value;
		refreshData(v_dev_ci_name, v_dev_ci_model);
	}
	function clearQueryText(){
		document.getElementById("s_dev_ci_name").value = "";
		document.getElementById("s_dev_ci_model").value = "";
	}
	function refreshData(v_dev_ci_name,v_dev_ci_model){
	
		var str = "select appdet.device_app_detid,appdet.project_info_no,sd.coding_name as unitname,teamsd.coding_name as teamname, ";
		str += "p6.name as jobname,devapp.device_app_name, ";
		str += "appdet.dev_name as dev_ci_name,";
		str += "appdet.dev_type as dev_ci_model, ";
		str += "appdet.apply_num,appdet.teamid,appdet.team, ";
		str += "appdet.purpose,appdet.employee_id,emp.employee_name, ";
		str += "appdet.plan_start_date,appdet.plan_end_date  ";
		str += "from gms_device_app_detail appdet ";
		str += "left join gms_device_app devapp on appdet.device_app_id = devapp.device_app_id and devapp.bsflag = '0' ";
		str += "left join bgp_p6_activity p6 on appdet.teamid = p6.object_id ";
		str += "left join comm_coding_sort_detail teamsd on appdet.team = teamsd.coding_code_id ";
		str += "left join comm_coding_sort_detail sd on appdet.unitinfo = sd.coding_code_id ";
		str += "left join gms_device_codeinfo ci on appdet.dev_ci_code = ci.dev_ci_code ";
		str += "left join gms_device_codetype ct on appdet.dev_ci_code = ct.dev_ct_code ";
		str += "left join comm_human_employee emp on appdet.employee_id = emp.employee_id ";
		str += "where devapp.device_app_id = '8ad8827146f7fd870146fa30accb098d' and appdet.bsflag='0' ";
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
	var showTabBox = document.getElementById("tab_box_content0");

	//打开新增界面
	function toAddPage(){
		popWindow('<%=contextPath%>/rm/dm/devmixPlan/mixdetail_new_apply.jsp?projectInfoNo=<%=projectInfoNo%>&deviceappid=<%=deviceappid%>','950:680');
	}
	//打开修改界面
	function toModifyPage(){
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
		popWindow('<%=contextPath%>/rm/dm/devmixPlan/mixdetail_modify_apply.jsp?projectInfoNo=<%=projectInfoNo%>&deviceappid=<%=deviceappid%>&deviceappdetid='+selectedid,'950:680');
	}
	function dbclickRow(shuaId){
		//判断状态
		var querySql = "select devapp.device_app_id,nvl(wfmiddle.proc_status,'') as proc_status ";
		querySql += "from gms_device_app devapp left join common_busi_wf_middle wfmiddle on devapp.device_allapp_id=wfmiddle.business_id ";
		querySql += "where devapp.bsflag='0' and devapp.device_app_id='<%=deviceappid%>' ";
		var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql);
		var basedatas = queryRet.datas;
		if(basedatas.length>=1 && (basedatas[0].proc_status == '0'||basedatas[0].proc_status == '3')){
			return;
		}
		popWindow('<%=contextPath%>/rm/dm/devmixPlan/mixdetail_modify_apply.jsp?projectInfoNo=<%=projectInfoNo%>&deviceappid=<%=deviceappid%>&deviceappdetid='+shuaId,'950:680');
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
			alert("请选择记录！");
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
		str += "appdet.dev_name as dev_ci_name,appdet.dev_type as dev_ci_model,devapp.device_app_name, ";
		str += "appdet.apply_num,appdet.teamid,appdet.team, ";
		str += "appdet.purpose,appdet.employee_id,emp.employee_name, ";
		str += "appdet.plan_start_date,appdet.plan_end_date  ";
		str += "from gms_device_app_detail appdet ";
		str += "left join gms_device_app devapp on appdet.device_app_id = devapp.device_app_id ";
		str += "left join bgp_p6_activity p6 on appdet.teamid = p6.object_id ";
		str += "left join comm_coding_sort_detail teamsd on appdet.team = teamsd.coding_code_id ";
		str += "left join comm_coding_sort_detail sd on appdet.unitinfo = sd.coding_code_id ";
		str += "left join gms_device_codeinfo ci on appdet.dev_ci_code = ci.dev_ci_code ";
		str += "left join comm_human_employee emp on appdet.employee_id = emp.employee_id ";
		str += "where devapp.device_app_id = '"+idinfo+"' and appdet.bsflag='0' ";
		str += "and appdet.device_app_detid= '"+deviceappdetid+"' and devapp.bsflag = '0' ";
		var unitRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+str);
		retObj = unitRet.datas;
		
		$("#device_app_name","#detailMap").val(retObj[0].device_app_name);
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
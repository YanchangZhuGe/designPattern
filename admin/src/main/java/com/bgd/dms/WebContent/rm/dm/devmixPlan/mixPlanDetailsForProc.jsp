<%@ page contentType="text/html;charset=utf-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
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
  <title>已添加的设备调配明细</title> 
 </head> 
 
 <body style="background:#fff" onload="refreshData()">
      	<div id="list_table" >
			<div id="table_box">
			  <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">		
			     <tr id='device_appdet_id_{device_app_detid}' name='device_app_detid'>
			     	<td class="bt_info_odd" exp="<input type='checkbox' name='selectedbox' value='{device_app_detid}' id='selectedbox_{device_app_detid}' />" >选择</td>
					<td class="bt_info_even" autoOrder="1">序号</td>
					<td class="bt_info_odd" exp="{project_name}">项目名称</td>
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
			    <li id="tag3_1"><a href="#" onclick="getContentTab(this,1)">附件</a></li>
			    <li id="tag3_1"><a href="#" onclick="getContentTab(this,2)">审批明细</a></li>
			    <li id="tag3_1"><a href="#" onclick="getContentTab(this,3)">备注</a></li>
			    <li id="tag3_1"><a href="#" onclick="getContentTab(this,4)">分类码</a></li>
			  </ul>
			</div>
			<div id="tab_box" class="tab_box">
				<div id="tab_box_content0" class="tab_box_content">
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
					</table>
				</div>
				<div id="tab_box_content1" class="tab_box_content" style="display:none;">
				
				</div>
				<div id="tab_box_content2" name="tab_box_content2" class="tab_box_content" style="display:none">
					<table id="approveList" width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" style="margin-top:2px;" >
				    	<tr class="bt_info">
				    	    <td>模板名称</td>
				            <td>序号</td>
				            <td>审批情况</td>		
				            <td>审批意见</td>
				            <td>审批人</td>			
				            <td>审批时间</td> 
				        </tr>            
			        </table>
				</div>
				<div id="tab_box_content3" name="tab_box_content3" class="tab_box_content" style="display:none">
					
				</div>
				<div id="tab_box_content4" name="tab_box_content2" class="tab_box_content" style="display:none">
					
				</div>
		 </div>
</div>
</body>
<script type="text/javascript">
function frameSize(){
	$("#tab_box").css("height",$(window).height()-$("#inq_tool_box").height()-$("#table_box").height()-$("#fenye_box").height()-60);
	//setTabBoxHeight();
}
frameSize();


$(function(){
	$(window).resize(function(){
  		frameSize();
	});
})	

$(document).ready(lashen);

$().ready(function(){
	var statestr = "select state from gms_device_app where device_app_id='<%=deviceappid%>' ";
	var unitRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+statestr);
	var stateObj = unitRet.datas;
	if(stateObj[0].state == '9'){
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

	
	function refreshData(v_dev_ci_name,v_dev_ci_model){
	
		var str = "select appdet.device_app_detid,appdet.project_info_no,sd.coding_name as unitname,teamsd.coding_name as teamname, ";
		str += "p6.name as jobname,pro.project_name,";
		str += "appdet.dev_name as dev_ci_name,";
		str += "appdet.dev_type as dev_ci_model, ";
		str += "appdet.apply_num,appdet.teamid,appdet.team, ";
		str += "appdet.purpose,appdet.employee_id,emp.employee_name, ";
		str += "appdet.plan_start_date,appdet.plan_end_date  ";
		str += "from gms_device_app_detail appdet ";
		str += "left join gms_device_app devapp on appdet.device_app_id = devapp.device_app_id ";
		str += "left join bgp_p6_activity p6 on appdet.teamid = p6.object_id ";
		str += "left join comm_coding_sort_detail teamsd on appdet.team = teamsd.coding_code_id ";
		str += "left join comm_coding_sort_detail sd on appdet.unitinfo = sd.coding_code_id ";
		str += "left join gp_task_project pro on appdet.project_info_no = pro.project_info_no ";
		str += "left join gms_device_codeinfo ci on appdet.dev_ci_code = ci.dev_ci_code ";
		str += "left join gms_device_codetype ct on appdet.dev_ci_code = ct.dev_ct_code ";
		str += "left join comm_human_employee emp on appdet.employee_id = emp.employee_id ";
		str += "where devapp.device_app_id = '"+idinfo+"' and appdet.bsflag='0' ";
		str += "and devapp.bsflag = '0' and appdet.bsflag='0'";
		if(v_dev_ci_name!=undefined && v_dev_ci_name!=''){
			str += "and ci.dev_ci_name like '"+v_dev_ci_name+"%' ";
		}
		if(v_dev_ci_model!=undefined && v_dev_ci_model!=''){
			str += "and ci.dev_ci_model like '"+v_dev_ci_model+"%' ";
		}
		cruConfig.queryStr = str;
		queryData(cruConfig.currentPage);
		
	}
</script>
<script type="text/javascript">	
	var selectedTagIndex = 0;
	var showTabBox = document.getElementById("tab_box_content0");

	//打开新增界面
	function toAddPage(){
		popWindow('<%=contextPath%>/rm/dm/devmixPlan/mixdetail_new_apply.jsp?projectInfoNo=<%=projectInfoNo%>&deviceappid=<%=deviceappid%>','950:680');
	}
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
		popWindow('<%=contextPath%>/rm/dm/devmixPlan/mixdetail_modify_apply.jsp?projectInfoNo=<%=projectInfoNo%>&deviceappid=<%=deviceappid%>&deviceappdetid='+selectedid,'950:680');
	}
	function dbclickRow(shuaId){
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
		str += "pro.project_name,appdet.dev_name as dev_ci_name,appdet.dev_type as dev_ci_model, ";
		str += "appdet.apply_num,appdet.teamid,appdet.team, ";
		str += "appdet.purpose,appdet.employee_id,emp.employee_name, ";
		str += "appdet.plan_start_date,appdet.plan_end_date  ";
		str += "from gms_device_app_detail appdet ";
		str += "left join gms_device_app devapp on appdet.device_app_id = devapp.device_app_id ";
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
    }
	
</script>
</html>
<%@ page contentType="text/html;charset=UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%@taglib uri="wf" prefix="wf"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String projectInfoNo = user.getProjectInfoNo();
	String projectType = user.getProjectType();
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
<script type="text/javascript" src="<%=contextPath%>/pm/bpm/common/processInfoCommon.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open1.js"></script>
  <title>调剂计划申请</title>
 </head> 
 
 <body style="background:#fff" onload="refreshData()">
      	<div id="list_table">
			<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			  	<td class="ali_cdn_name">项目名称</td>
			    <td class="ali_cdn_input">
			    	<input id="s_project_name" name="s_project_name" type="text" class="input_width" />
			    </td>
			    <td class="ali_cdn_name">单位名称</td>
			    <td class="ali_cdn_input">
			    	<input id="s_org_name" name="s_org_name" type="text" class="input_width" />
			    </td>
			    <td class="ali_query">
			    	<span class="cx"><a href="#" onclick="searchDevData()" title="查询"></a></span>
			    </td>
			    <td class="ali_query">
				    <span class="qc"><a href="#" onclick="clearQueryText()" title="清除"></a></span>
			    </td>
			    <td>&nbsp;</td>
			    <auth:ListButton functionId="" css="zj" event="onclick='toAdd()'" title="新增"></auth:ListButton>
			    <auth:ListButton functionId="" css="xg" event="onclick='toModify()'" title="修改"></auth:ListButton>
			    <auth:ListButton functionId="" css="sc" event="onclick='toDelete()'" title="删除"></auth:ListButton>
			    <auth:ListButton functionId="" css="dc" event="onclick='exportData()'" title="导出excel"></auth:ListButton>
			    <auth:ListButton functionId="" css="tj" event="onclick='toSumbit()'" title="提交"></auth:ListButton>
			    <auth:ListButton functionId="" css="jl" event="onclick='toModifyDetail()'" title="编辑明细"></auth:ListButton>
			  </tr>
			</table>
			</td>
			    <td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
			  </tr>
			</table>
			</div>
			<div id="table_box">
			  <table style="width:98.5%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">		
			     <tr id='device_app_id_{device_app_id}' name='device_app_id' ondblclick='toModifyDetail(this)' idinfo='{device_app_id}'>
			     	<td class="bt_info_odd" exp="<input type='checkbox' name='selectedbox' value='{device_app_id}' id='selectedbox_{device_app_id}' onclick='chooseOne(this)'/>" >选择</td>
					<td class="bt_info_even" autoOrder="1">序号</td>
					<td class="bt_info_odd" exp="{project_name}">项目名称</td>
					<td class="bt_info_even" exp="{device_allapp_no}">配置计划单号</td>
					<td class="bt_info_odd" exp="{device_allapp_name}">配置计划单名称</td>
					<td class="bt_info_even" exp="{device_app_no}">调剂申请单号</td>
					<td class="bt_info_odd" exp="{device_app_name}">调剂申请单名称</td>
					<td class="bt_info_even" exp="{org_name}">申请单位名称</td>
					<td class="bt_info_odd" exp="{employee_name}">经办人</td>
					<td class="bt_info_even" exp="{appdate}">申请时间</td>
					<td class="bt_info_odd" exp="{state_desc}">状态</td>
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
			    <li id="tag3_1"><a href="#" onclick="getContentTab(this,1)">明细信息</a></li>
			    <li id="tag3_1"><a href="#" onclick="getContentTab(this,2)">审批明细</a></li>
			    <li id="tag3_1"><a href="#" onclick="getContentTab(this,3)">附件</a></li>
			    <li id="tag3_1"><a href="#" onclick="getContentTab(this,4)">备注</a></li>
			    <li id="tag3_1"><a href="#" onclick="getContentTab(this,5)">分类码</a></li>
			  </ul>
			</div>
			<div id="tab_box" class="tab_box">
				<div id="tab_box_content0" name="tab_box_content0" class="tab_box_content">
					<table id="projectMap" name="projectMap" border="0" cellpadding="0" cellspacing="0"  class="tab_line_height" width="100%" style="margin-top:10px;background:#efefef"> 
					<tr>
				      <td  class="inquire_item6">项目名称：</td>
				      <td  class="inquire_form6" ><input id="project_name" class="input_width" type="text" value="" disabled/>&nbsp;</td>
				      <td  class="inquire_item6">配置计划单名称：</td>
				      <td  class="inquire_form6"><input id="device_allapp_name" class="input_width" type="text"  value="" disabled/> &nbsp;</td>
				      <td  class="inquire_item6">&nbsp;配置计划单号：</td>
				      <td  class="inquire_form6"  ><input id="device_allapp_no" class="input_width" type="text"  value="" disabled/> &nbsp;</td>
				     </tr>
				    <tr>
				      <td  class="inquire_item6">调剂申请单名称：</td>
				      <td  class="inquire_form6"><input id="device_app_name" class="input_width" type="text"  value="" disabled/> &nbsp;</td>
				      <td  class="inquire_item6">&nbsp;调剂申请单号：</td>
				      <td  class="inquire_form6"  ><input id="device_app_no" class="input_width" type="text"  value="" disabled/> &nbsp;</td>
				      <td  class="inquire_item6">申请单位名称：</td>
				      <td  class="inquire_form6"><input id="org_name" class="input_width" type="text"  value="" disabled/> &nbsp;</td> 
				     </tr>
				    <tr >
				     <td  class="inquire_item6">&nbsp;申请人：</td>
				     <td  class="inquire_form6"><input id="employee_name" class="input_width" type="text"  value="" disabled/> &nbsp;</td>  
				     <td  class="inquire_item6">申请时间：</td>
				     <td  class="inquire_form6"><input id="appdate" class="input_width" type="text"  value="" disabled/> &nbsp;</td> 
				     <td  class="inquire_item6">&nbsp;状态：</td>
				     <td  class="inquire_form6"><input id="state_desc" class="input_width" type="text"  value="" disabled/> &nbsp;</td>
				    </tr>
				    <tr>
				     <td  class="inquire_item6">创建时间：</td>
				     <td  class="inquire_form6"><input id="createdate" class="input_width" type="text"  value="" disabled/> &nbsp;</td> 
				     <td  class="inquire_item6">&nbsp;审核时间：</td>
				     <td  class="inquire_form6"><input id="approvedate" class="input_width" type="text"  value="" disabled/> &nbsp;</td>
				     <td colspan='2'>&nbsp;</td>
				    </tr>
					</table>
				</div>
				<div id="tab_box_content1" name="tab_box_content1" idinfo="" class="tab_box_content" style="display:none">
					<table border="0" cellpadding="0" cellspacing="0"  class="tab_line_height" width="100%" style="margin-top:10px;background:#efefef"> 
						<tr class="bt_info">
				            <td class="bt_info_even">序号</td>
							<td class="bt_info_odd">项目名称</td>
							<td class="bt_info_even">班组</td>
							<td class="bt_info_odd">设备名称</td>
							<td class="bt_info_even">规格型号</td>
							<td class="bt_info_odd">单位</td>
							<td class="bt_info_even">申请数量</td>
							<td class="bt_info_odd">申请人</td>
							<td class="bt_info_even">用途</td>
							<td class="bt_info_odd">计划开始时间</td>
							<td class="bt_info_even">计划结束时间</td>		
				        </tr>
				        <tbody id="detailMap" name="detailMap" ></tbody>
					</table>
				</div>
				<div id="tab_box_content2" name="tab_box_content2" class="tab_box_content" style="display:none">
					<wf:startProcessInfo  buttonFunctionId="F_OP_002" title=""/>
				</div>
				<div id="tab_box_content3" name="tab_box_content3" class="tab_box_content" style="display:none">
					<iframe width="100%" height="100%" name="attachement" id="attachement" frameborder="0" src="" marginheight="0" marginwidth="0" ></iframe>
				</div>
				<div id="tab_box_content4" name="tab_box_content4" class="tab_box_content" style="display:none">
					<iframe width="100%" height="100%" name="remark" id="remark" frameborder="0" src="" marginheight="0" marginwidth="0" ></iframe>
				</div>
				<div id="tab_box_content5" name="tab_box_content5" class="tab_box_content" style="display:none">
					<iframe width="100%" height="100%" name="codeManager" id="codeManager" frameborder="0" src="" marginheight="0" marginwidth="0"  scrolling="auto" style="overflow: scroll;"></iframe>
				</div>
		 </div>
</div>
</body>
<script type="text/javascript">
var project_type="<%=projectType%>";
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
				var str = "select appdet.device_app_detid,appdet.project_info_no,sd.coding_name as unitname,teamsd.coding_name as teamname, ";
				str += "p6.name as jobname,pro.project_name,";
				str += "case when appdet.isdevicecode='N' then ci.dev_ci_name else ct.dev_ct_name end as dev_ci_name,";
				str += "case when appdet.isdevicecode='N' then ci.dev_ci_model else '' end as dev_ci_model, ";
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
				str += "left join gms_device_codetype ct on appdet.dev_ci_code = ct.dev_ct_code ";
				str += "left join comm_human_employee emp on appdet.employee_id = emp.employee_id ";
				str += "where devapp.device_app_id = '"+currentid+"' and appdet.bsflag='0' ";
				str += "and devapp.bsflag = '0' ";
				var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+str);
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
		}else if(index == 3){
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
			innerHTML += "<td>"+(i+1)+"</td><td>"+datas[i].project_name+"</td><td>"+datas[i].teamname+"</td>";
			innerHTML += "<td>"+datas[i].dev_ci_name+"</td><td>"+datas[i].dev_ci_model+"</td><td>"+datas[i].unitname+"</td>";
			innerHTML += "<td>"+datas[i].apply_num+"</td><td>"+datas[i].employee_name+"</td><td>"+datas[i].purpose+"</td>";
			innerHTML += "<td>"+datas[i].plan_start_date+"</td><td>"+datas[i].plan_end_date+"</td>";
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
	
    function refreshData(v_project_name,v_org_name){
		var str = "select pro.project_name,devapp.device_app_id,devapp.device_app_no,devapp.device_app_name,devapp.project_info_no,";
			str += "devapp.org_id,devapp.employee_id,devapp.appdate,devapp.create_date,devapp.modifi_date,";
			str += "case wfmiddle.proc_status when '1' then '待审批' when '3' then '审批通过' when '4' then '审批不通过' else '未提交' end as state_desc,";
			str += "org.org_abbreviation as org_name,emp.employee_name,allapp.device_allapp_name,allapp.device_allapp_no ";
			str += "from gms_device_disapp devapp  ";
			str += "left join common_busi_wf_middle wfmiddle on wfmiddle.business_id = devapp.device_app_id  ";
			str += "left join gms_device_allapp allapp on devapp.device_allapp_id = allapp.device_allapp_id ";
			str += "left join common_busi_wf_middle allwfmiddle on allwfmiddle.business_id = allapp.device_allapp_id  ";
			str += "left join comm_org_information org on devapp.org_id = org.org_id  ";
			str += "left join comm_human_employee emp on devapp.employee_id = emp.employee_id ";
			str += "left join gp_task_project pro on devapp.project_info_no=pro.project_info_no ";
			str += "where devapp.bsflag = '0' and  devapp.project_info_no='"+projectInfoNos+"' ";
			str += " and allwfmiddle.proc_status='3' ";
		/* 补充查询条件
		if(v_dev_ci_name!=undefined && v_dev_ci_name!=''){
			str += "and ci.dev_ci_name like '"+v_dev_ci_name+"%' ";
		}
		if(v_dev_ci_model!=undefined && v_dev_ci_model!=''){
			str += "and ci.dev_ci_model like '"+v_dev_ci_model+"%' ";
		}
		*/
		cruConfig.queryStr = str;
		queryData(cruConfig.currentPage);;
	}
    function loadDataDetail(device_app_id){
    	var retObj;
		if(device_app_id!=null){
			 retObj = jcdpCallService("DispensingDevSrv", "getDisAppBaseInfo", "deviceappid="+device_app_id);
			
		}else{
			var ids = getSelIds('selectedbox');
		    if(ids==''){ 
			    alert("请先选中一条记录!");
	     		return;
		    }
		    retObj = jcdpCallService("DispensingDevSrv", "getDisAppBaseInfo", "deviceappid="+ids);
		}
		//选中这一条checkbox
		$("#selectedbox_"+retObj.deviceappMap.device_app_id).attr("checked","checked");
		//取消其他选中的
		$("input[type='checkbox'][name='selectedbox'][id!='selectedbox_"+retObj.deviceappMap.device_app_id+"']").removeAttr("checked");
		//给数据回填
		$("#project_name","#projectMap").val(retObj.deviceappMap.project_name);
		$("#device_allapp_name","#projectMap").val(retObj.deviceappMap.device_allapp_name);
		$("#device_allapp_no","#projectMap").val(retObj.deviceappMap.device_allapp_no);
		$("#device_app_name","#projectMap").val(retObj.deviceappMap.device_app_name);
		$("#device_app_no","#projectMap").val(retObj.deviceappMap.device_app_no);
		$("#state_desc","#projectMap").val(retObj.deviceappMap.state_desc);
		$("#org_name","#projectMap").val(retObj.deviceappMap.org_name);
		$("#employee_name","#projectMap").val(retObj.deviceappMap.employee_name);
		$("#appdate","#projectMap").val(retObj.deviceappMap.appdate);
		$("#createdate","#projectMap").val(retObj.deviceappMap.createdate);
		var device_app_name = retObj.deviceappMap.device_app_name;
		var device_app_no = retObj.deviceappMap.device_app_no;
		var curbusinesstype = "";
		if(project_type == '5000100004000000008'){//井中
			curbusinesstype = "5110000004100001065";
		}else{
			curbusinesstype = "5110000004100000046";
		}
		//重新加载当前标签页信息
		getContentTab(undefined,selectedTagIndex);
		//工作流信息
		var submitdate =getdate();
    	processNecessaryInfo={        							//流程引擎关键信息
			businessTableName:"gms_device_disapp",    				//置入流程管控的业务表的主表表明
			businessType:curbusinesstype,    				//业务类型 即为之前设置的业务大类
			businessId:device_app_id,           				//业务主表主键值
			businessInfo:"设备调剂申请审批信息<调剂单名称:"+device_app_name+";调剂单号:"+device_app_no+">",
			applicantDate:submitdate       						//流程发起时间
		};
		processAppendInfo={ 									//流程引擎附加临时变量信息
			projectInfoNo:projectInfoNos,
			deviceappid:device_app_id
		};
    	loadProcessHistoryInfo();
    }
    
	function toAdd(){
		if('<%=projectInfoNo%>'!=null){
			//查询基本信息
			var querySql = "select allapp.device_allapp_id, ";
			querySql += "nvl(wfmiddle.proc_status,'') as proc_status ";
			querySql += "from gms_device_allapp allapp left join common_busi_wf_middle wfmiddle on allapp.device_allapp_id=wfmiddle.business_id ";
			querySql += "where allapp.bsflag='0' and allapp.project_info_no='<%=projectInfoNo%>'";
			var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql);
			basedatas = queryRet.datas;
		}
		if(basedatas.length == 0){
			alert("您未填写配置计划申请,请检查!");
		}else if(basedatas.length == 1&&basedatas[0].proc_status == ''){
			alert("您未提交配置计划申请,请检查!");
		}else if(basedatas.length == 1&&basedatas[0].proc_status == '0'){
			alert("您提交的配置计划申请审批中，请查看审批信息!");
		}else if(basedatas.length == 1&&basedatas[0].proc_status == '4'){
			alert("您提交的配置计划申请审批不通过，请查看审批信息!");
		}else{
			popWindow('<%=contextPath%>/rm/dm/devdis/displanAdd.jsp?projectInfoNo=<%=projectInfoNo%>',"900:680");
		}
	}
	function toModify(){
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
		var querySql = "select devapp.device_app_id,nvl(wfmiddle.proc_status,'') as proc_status ";
		querySql += "from gms_device_disapp devapp left join common_busi_wf_middle wfmiddle on devapp.device_app_id=wfmiddle.business_id ";
		querySql += "where devapp.bsflag='0' and devapp.device_app_id in ("+selectedid+")";
		var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql);
		var basedatas = queryRet.datas;
		var stateflag = false;
		var alertinfo ;
		for(var index = 0;index<basedatas.length;index++){
			if(basedatas[index].proc_status == '3' ){
				stateflag = true;
				alertinfo = "您选择的记录状态为'审批通过'，不能修改!";
				break;
			}else if(basedatas[index].proc_status == '1' ){
				stateflag = true;
				alertinfo = "您选择的记录状态为'待审批''，不能修改!";
				break;
			}
		}
		if(stateflag){
			alert(alertinfo);
			return;
		}
		var deviceappid ;
		$("input[type='checkbox'][name='selectedbox']").each(function(){
			if(this.checked){
				deviceappid = this.value;
			}
		});
		popWindow('<%=contextPath%>/rm/dm/devdis/displanModify.jsp?projectInfoNo=<%=projectInfoNo%>&deviceappid='+deviceappid,"900:680");
	}
	
	function toDelete(){
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
		var querySql = "select devapp.device_app_id,nvl(wfmiddle.proc_status,'') as proc_status ";
		querySql += "from gms_device_disapp devapp left join common_busi_wf_middle wfmiddle on devapp.device_app_id=wfmiddle.business_id ";
		querySql += "where devapp.bsflag='0' and devapp.device_app_id in ("+selectedid+")";
		var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql);
		var basedatas = queryRet.datas;
		var stateflag = false;
		var alertinfo ;
		for(var index = 0;index<basedatas.length;index++){
			if(basedatas[index].proc_status == '3' ){
				stateflag = true;
				alertinfo = "您选择的记录中存在状态为'待审批'的单据,不能删除!";
				break;
			}else if(basedatas[index].state == '3' ){
				stateflag = true;
				alertinfo = "您选择的记录中存在状态为'审批通过'的单据,不能删除!";
				break;
			}
		}
		if(stateflag){
			alert(alertinfo);
			return;
		}
		//什么状态不能删除，和业务专家确定
		if(confirm("是否执行删除操作?")){
			var sql = "update gms_device_disapp set bsflag='1' where device_app_id in ("+selectedid+")";
			var path = cruConfig.contextPath+"/rad/asyncDelete.srq";
			var params = "deleteSql="+sql;
			params += "&ids=";
			var retObject = syncRequest('Post',path,params);
			refreshData();
		}
	}
	function toSumbit(){
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
		
		//判断状态
		var querySql = "select devapp.device_app_id,nvl(wfmiddle.proc_status,'') as proc_status ";
		querySql += "from gms_device_disapp devapp left join common_busi_wf_middle wfmiddle on devapp.device_app_id=wfmiddle.business_id ";
		querySql += "where devapp.bsflag='0' and devapp.device_app_id in ("+selectedid+")";
		var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql);
		var basedatas = queryRet.datas;
		
		var stateflag = false;
		var alertinfo ;
		for(var index = 0;index<basedatas.length;index++){
			if(basedatas[index].state == '1' ){
				stateflag = true;
				alertinfo = "您选择的记录中存在状态为'待审批'的单据,不能提交!";
				break;
			}else if(basedatas[index].state == '3' ){
				stateflag = true;
				alertinfo = "您选择的记录中存在状态为'审批通过'的单据,不能提交!";
				break;
			}
		}
		if(stateflag){
			alert(alertinfo);
			return;
		}
		//判断主记录中是否有明细
		var querySql = "select count(1) as subcount ";
		querySql += "from gms_device_disapp_detail appdet where appdet.device_app_id in ("+selectedid+")";
		var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql);
		var basedatas = queryRet.datas;
		if(basedatas[0].subcount==0){
			alert("您提交的记录没有添加明细,请查看!");
			return;
		}
		if (!window.confirm("确认要提交吗?")) {
			return;
		}
		submitProcessInfo();
		refreshData();
		alert('提交成功！');
	}
	
	function toModifyDetail(obj){
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
		window.location.href='<%=contextPath%>/rm/dm/devdis/disPlanDetailList.jsp?projectInfoNo=<%=projectInfoNo%>&deviceappid='+idinfo;
	}
	function dbclickRow(shuaId){
		window.location.href='<%=contextPath%>/rm/dm/devdis/disPlanDetailList.jsp?projectInfoNo=<%=projectInfoNo%>&deviceappid='+shuaId;
	}
	
	function simpleRefreshData(){
		if (window.event.keyCode == 13) {
			var v_project_name = document.getElementById("s_project_name").value;
			var v_org_name = document.getElementById("s_org_name").value;
			refreshData(v_project_name, v_org_name);
		}
	}
	
	function searchDevData(){
		var v_project_name = document.getElementById("s_project_name").value;
		var v_org_name = document.getElementById("s_org_name").value;
		refreshData(v_project_name, v_org_name);
	}
	
	function toSubmit() {
		//jcdpCallService("HumanCommInfoSrv","submitHumanPlan","projectInfoNo=<%=projectInfoNo%>&procStatus=1");	
		alert("提交成功!");
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

</script>
</html>
<%@ page contentType="text/html;charset=UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%@taglib uri="wf" prefix="wf"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String projectInfoNo = user.getProjectInfoNo();
	String projectName = user.getProjectName();
	String userId = user.getOrgSubjectionId();
	//System.out.println("userId == "+userId);
	
	String orgSub = user.getSubOrgIDofAffordOrg();
	String	projectType = request.getParameter("projectType")==null?user.getProjectType():request.getParameter("projectType");
	//"8a9588b63618fc0d01361a93e0bf0018";
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

  <title>多项目-计划管理-配置计划-补充设备配置计划</title>
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
			    <auth:ListButton functionId="" css="dc" event="onclick='exportData()'" title="导出excel"></auth:ListButton>
			  </tr>
			</table>
			</td>
			    <td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
			  </tr>
			</table>
			</div>
			<div id="table_box">
			  <table style="width:98.5%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">		
			     <tr id='device_addapp_id_{device_addapp_id}' name='device_addapp_id' ondblclick='toModifyDetail(this)' idinfo='{device_addapp_id}'>
			     	<td class="bt_info_odd" exp="<input type='checkbox' name='selectedbox' value='{device_addapp_id}' id='selectedbox_{device_addapp_id}' onclick='chooseOne(this)'/>" >选择</td>
					<td class="bt_info_even" autoOrder="1">序号</td>
					<td class="bt_info_odd" exp="{project_name}">项目名称</td>
					<td class="bt_info_even" exp="{device_allapp_no}">配置计划单号</td>
					<td class="bt_info_odd" exp="{device_allapp_name}">配置计划单名称</td>
					<td class="bt_info_even" exp="{device_addapp_no}">调配补充计划单号</td>
					<td class="bt_info_odd" exp="{device_addapp_name}">调配补充计划单名称</td>
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
			    <!-- <li id="tag3_1"><a href="#" onclick="getContentTab(this,5)">分类码</a></li> -->
			  </ul>
			</div>
			<div id="tab_box" class="tab_box">
				<div id="tab_box_content0" name="tab_box_content0" class="tab_box_content">
					<table id="projectMap" name="projectMap" border="0" cellpadding="0" cellspacing="0"  class="tab_line_height" width="100%" style="margin-top:10px;background:#efefef"> 
					<tr>
				        <td  class="inquire_item6">项目名称：</td>
				        <td  class="inquire_form6" >
				        <input id="project_name" class="input_width" type="text" value="" disabled/>&nbsp;</td>
						
						<td class="inquire_item6">施工队伍：</td>
					    <td class="inquire_form6"><input type="text" id="org_name" name="org_name" class="input_width" readonly="readonly"/></td>
					    <td class="inquire_item6">作业组数量：</td>
						<td class="inquire_form6"><input type="text" value="" id="working_group" name="working_group" class="input_width" readonly="readonly"/></td>
				     </tr>
				   <tr>
				  		<td class="inquire_item6">队经理：</td>
						<td class="inquire_form6">
						<input type="text" id="team_manager" name="team_manager" class="input_width" readonly="readonly"/></td>
						<td class="inquire_item6">副队经理：</td>
						<td class="inquire_form6">
						<input type="text" id="team_manager_f" name="team_manager_f" class="input_width" readonly="readonly"/></td>
						<td class="inquire_item6">指导员：</td>
						<td class="inquire_form6">
						<input type="text" id="instructor" name="instructor" class="input_width" readonly="readonly"/></td>
					</tr>
					<tr>
						<td class="inquire_item6">工期要求：</td>
						<td class="inquire_form6">
						<input type="text" id="time_limit" name="time_limit" class="input_width" readonly="readonly"/></td>
					</tr>
					<tr>
						<td class="inquire_item6">工作量：</td>
						<td id="item_workload" class="inquire_form6" colspan="3"></td>
					</tr>
				  	<tr>
				  		<td class="inquire_item6">地形：</td>
						<td id="item_landform" class="inquire_form6" colspan="3"></td>
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
							<td class="bt_info_odd">审批数量</td>
							<td class="bt_info_even">申请人</td>
							<td class="bt_info_odd">计划开始时间</td>
							<td class="bt_info_even">计划结束时间</td>
							<td class="bt_info_odd">用途</td>	
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
				var str = "select * from ("
				str += "select alldet.device_allapp_detid,alldet.project_info_no,sd.coding_name as unitname,teamsd.coding_name as teamname, ";
				str += "p6.name as jobname,pro.project_name,";
				str += "alldet.dev_name as dev_ci_name,";
				str += "alldet.dev_type as dev_ci_model, ";
				str += "alldet.apply_num,alldet.approve_num,alldet.teamid,alldet.team, ";
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
				str += "where alldet.device_addapp_id ='"+currentid+"' and (alldet.bsflag = '0' or alldet.bsflag='N') ";
				str += "union all "
				str += "select alldet.device_allapp_detid,alldet.project_info_no,sd.coding_name as unitname,teamsd.coding_name as teamname, ";
				str += "p6.name as jobname,pro.project_name,alldet.dev_name_input as dev_ci_name,devtype.coding_name as dev_ci_model, ";
				str += "alldet.apply_num,alldet.approve_num,alldet.teamid,alldet.team, ";
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
				str += "where alldet.device_addapp_id ='"+currentid+"' and (alldet.bsflag = '0' or alldet.bsflag='N') ";
				str += ") order by seqinfo ";
				var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+str+'&pageSize=1000');
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
		}
		
		$(filternotobj).hide();
		$(filterobj).show();
	}
	
	function appendDataToDetailTab(filterobj,datas){
		for(var i=0;i<basedatas.length;i++){
			var innerHTML = "<tr>";
			innerHTML += "<td>"+(i+1)+"</td><td>"+datas[i].project_name+"</td><td>"+datas[i].teamname+"</td>";
			innerHTML += "<td>"+datas[i].dev_ci_name+"</td><td>"+datas[i].dev_ci_model+"</td><td>"+datas[i].unitname+"</td>";
			innerHTML += "<td>"+datas[i].apply_num+"</td><td>"+datas[i].approve_num+"</td><td>"+datas[i].employee_name+"</td>";
			innerHTML += "<td>"+datas[i].plan_start_date+"</td><td>"+datas[i].plan_end_date+"</td><td>"+datas[i].purpose+"</td>";
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
	var projectType="<%=projectType%>";
	cruConfig.contextPath =  "<%=contextPath%>";
	var userId="<%=userId%>";
	var orgSub="<%=orgSub%>";
	cruConfig.cdtType = 'form';

	function clearQueryText(){
		$("#s_project_name").val("");
		$("#s_org_name").val("");
	}
	
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
        
    	var str = "select project_name,device_addapp_id,device_addapp_no,";
    		str += "device_addapp_name,project_info_no,org_id,employee_id,";
    		str += "appdate,create_date,modifi_date,device_allapp_id,state_desc ";
    		str += ",org_name,employee_name,device_allapp_name,";
    		str += "case state_desc when '未提交' then '0' when '待审批' then '1' when '审批不通过' then '2' else '3' end ";
    		str += "as state_asc,device_allapp_no from(";
    		str += "select pro.project_name,devapp.device_addapp_id,devapp.device_addapp_no,devapp.device_addapp_name,devapp.project_info_no,";
			str += "devapp.org_id,devapp.employee_id,devapp.appdate,devapp.create_date,devapp.modifi_date,devapp.device_allapp_id,";
			str += "case wfmiddle.proc_status when '1' then '待审批' when '3' then '审批通过' when '4' then '审批不通过' else '未提交' end as state_desc,";
			str += "org.org_abbreviation as org_name,emp.employee_name,allapp.device_allapp_name,allapp.device_allapp_no ";
			str += "from gms_device_allapp_add devapp  ";
			
			if(projectType == "5000100004000000009")
	        {
				str += "left join common_busi_wf_middle wfmiddle on wfmiddle.business_id = devapp.project_info_no and wfmiddle.bsflag='0' ";
	        }else{
	        	str += "left join common_busi_wf_middle wfmiddle on wfmiddle.business_id = devapp.device_addapp_id and wfmiddle.bsflag='0' ";
	         }
			str += "and wfmiddle.business_type = '5110000004100000096' " 
			str += "left join gms_device_allapp allapp on devapp.device_allapp_id = allapp.device_allapp_id and allapp.bsflag = '0' ";
			str += "left join common_busi_wf_middle allwfmiddle on allwfmiddle.business_id = allapp.device_allapp_id and allwfmiddle.bsflag='0' ";
			str += "left join comm_org_information org on devapp.org_id = org.org_id  "; 
			str += "left join comm_human_employee emp on devapp.employee_id = emp.employee_id ";
			str += "left join gp_task_project pro on devapp.project_info_no=pro.project_info_no ";

			//综合物化探：C105008038-测绘服务中心; C105008042-机动设备服务中心; C105008001-仪器服务中心
			if(userId == 'C105008038' || userId == 'C105008042' || userId == 'C105008001')
			{			
				str += "where devapp.bsflag = '0' and devapp.org_subjection_id like '%C105008%' ";
				
			}//综合物化探：C105008037-北疆项目部; C105008039-东部项目部; C105008040-敦煌项目部
			 //           C105008044-塔里木项目部; C105008003-海外项目部; C105008002-工程项目部;
			else if(userId == 'C105008037' || userId == 'C105008039' || userId == 'C105008040'
				|| userId == 'C105008044' || userId == 'C105008003' || userId == 'C105008002')
			{
				//str += "where devapp.bsflag = '0' and devapp.org_subjection_id like '%<%=userId%>%' ";
				str += "where devapp.bsflag = '0' and devapp.org_subjection_id like '%C105008%' ";

				if(userId == 'C105008037')
				{
					str += "and pro.project_department = 'C6000000005592' "
				}else if(userId == 'C105008039')
				{
					str += "and pro.project_department = 'C6000000005594' "
				}else if(userId == 'C105008040')
				{
					str += "and pro.project_department = 'C6000000005595' "
				}else if(userId == 'C105008044')
				{
					str += "and pro.project_department = 'C6000000005605' "
				}else if(userId == 'C105008003')
				{
					str += "and pro.project_department = 'C6000000000124' "
				}else if(userId == 'C105008002')
				{
					str += "and pro.project_department = 'C6000000004707' "
				}
			}
			else
			{
				str += "where devapp.bsflag = '0' and devapp.org_subjection_id like '%<%=orgSub%>%' ";
			}

			if(v_project_name!=undefined && v_project_name!=''){
				str += "and pro.project_name like '%"+v_project_name+"%' ";
			}
			if(v_org_name!=undefined && v_org_name!=''){
				str += "and org.org_name like '%"+v_org_name+"%' ";
			}
			
			str += "and allwfmiddle.proc_status='3' order by state_desc desc, devapp.appdate desc) order by state_asc asc,create_date desc";
			
		// 补充查询条件
		//if(v_dev_ci_name!=undefined && v_dev_ci_name!=''){
	//		str += "and ci.dev_ci_name like '"+v_dev_ci_name+"%' ";
		//}
	//	if(v_dev_ci_model!=undefined && v_dev_ci_model!=''){
	//		str += "and ci.dev_ci_model like '"+v_dev_ci_model+"%' ";
	//	}
			
		
		cruConfig.queryStr = str;
		queryData(cruConfig.currentPage);
	}
    function loadDataDetail(device_addapp_id){
    	var retObj;
		if(device_addapp_id!=null){
			 retObj = jcdpCallService("DevCommInfoSrv", "getDevAllAddAppBaseInfo", "deviceaddappid="+device_addapp_id);
			
		}else{
			var ids = getSelIds('selectedbox');
		    if(ids==''){ 
			    alert("请先选中一条记录!");
	     		return;
		    }
		    retObj = jcdpCallService("DevCommInfoSrv", "getDevAllAddAppBaseInfo", "deviceaddappid="+ids);
		}
		//选中这一条checkbox
		$("#selectedbox_"+retObj.deviceappMap.device_addapp_id).attr("checked","checked");
		//取消其他选中的
		$("input[type='checkbox'][name='selectedbox'][id!='selectedbox_"+retObj.deviceappMap.device_addapp_id+"']").removeAttr("checked");
	
		//重新加载当前标签页信息
		getContentTab(undefined,selectedTagIndex);
		//工作流信息
		var submitdate =getdate();
    	var device_addapp_name = retObj.deviceappMap.device_addapp_name;
    	processNecessaryInfo={        							//流程引擎关键信息
			businessTableName:"gms_device_allapp_add",   		//置入流程管控的业务表的主表表明
			businessType:"5110000004100000096",    				//业务类型 即为之前设置的业务大类
			businessId:device_addapp_id,           				//业务主表主键值
			businessInfo:"设备配置补充计划审批<变更计划单名称:"+device_addapp_name+">",	//用于待审批界面展示业务信息
			applicantDate:submitdate       						//流程发起时间
		};
		processAppendInfo={ 	
			projectName:projectName,								//流程引擎附加临时变量信息
			projectInfoNo:projectInfoNos,
			deviceaddappid:device_addapp_id
		};
    	loadProcessHistoryInfo();


		var retObj = jcdpCallService("WtProjectSrv", "getProjectResourcesInfo","projectInfoNo="+retObj.deviceappMap.project_info_no);
    	
	    document.getElementById("project_name").value=retObj.map==null?"":retObj.map.project_name;
	    document.getElementById("org_name").value=retObj.map==null?"":retObj.orgMap.org_name;
	    document.getElementById("working_group").value=retObj.map==null?"":retObj.map.working_group;
	    document.getElementById("team_manager").value=retObj.map==null?"":retObj.map.team_manager;
	    document.getElementById("team_manager_f").value=retObj.map==null?"":retObj.map.team_manager_f;
	    document.getElementById("instructor").value=retObj.map==null?"":retObj.map.instructor;
	    document.getElementById("time_limit").value=retObj.map==null?"":retObj.map.time_limit;
	    //工作量
	    document.getElementById("item_workload").innerHTML="<textarea id='work_load'  name='work_load' cols='63' rows='10' readonly='true'>"+(retObj.map==null?"":retObj.map.work_load)+"</textarea>";
	    //地形
	    document.getElementById("item_landform").innerHTML="<textarea id='landform' name='landform' cols='63' rows='5' readonly='true'>"+(retObj.map==null?"":retObj.map.landform)+"</textarea>";
    }
	
	function searchDevData(){
		var v_project_name = document.getElementById("s_project_name").value;
		var v_org_name = document.getElementById("s_org_name").value;
		refreshData(v_project_name, v_org_name);
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
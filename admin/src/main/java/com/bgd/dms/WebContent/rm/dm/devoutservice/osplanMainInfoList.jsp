<%@page contentType="text/html;charset=utf-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%@taglib uri="wf" prefix="wf"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String projectInfoNo = user.getProjectInfoNo();
	String projectName = user.getProjectName();
	String projectCommon = user.getProjectCommon();
	String projectType = request.getParameter("projectType")==null?user.getProjectType():request.getParameter("projectType");

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
  <title>队级设备报停申请</title> 
 </head> 
 
 <body style="background:#fff" onload="refreshData()">
      	<div id="list_table">
			<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  </tr>
			  <tr>
			  	<td class="ali_cdn_name">项目名称</td>
			    <td class="ali_cdn_input">
			    	<input id="s_project_name" name="s_project_name" type="text" class="input_width" />
			    </td>
			    <td class="ali_cdn_name">申请单号</td>
			    <td class="ali_cdn_input">
			    	<input id="s_dev_osapp_no" name="s_dev_osapp_no" type="text" class="input_width" />
			    </td>
			    <td class="ali_query">
			    	<span class="cx"><a href="#" onclick="searchDevData()" title="查询"></a></span>
			    </td>
			    <td class="ali_query">
				    <span class="qc"><a href="#" onclick="clearQueryText()" title="清除"></a></span>
			    </td>
			    <td>&nbsp;</td>
			    <auth:ListButton functionId="" css="zj" event="onclick='toAddMainPlanPage()'" title="新增"></auth:ListButton>
			    <auth:ListButton functionId="" css="xg" event="onclick='toModifyMainPlanPage()'" title="修改"></auth:ListButton>
			    <auth:ListButton functionId="" css="sc" event="onclick='toDelPlanPage()'" title="删除"></auth:ListButton>
			    <auth:ListButton functionId="" css="dc" event="onclick='exportData()'" title="导出excel"></auth:ListButton>
			    <auth:ListButton functionId="" css="tj" event="onclick='toSumbitDevApp()'" title="提交"></auth:ListButton>
			  </tr>
			</table>
			</td>
			    <td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
			  </tr>
			</table>
			</div>
			<div id="table_box">
			  <table style="width:98.5%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">		
			     <tr id='device_osapp_id_{device_osapp_id}' name='device_osapp_id' idinfo='{device_osapp_id}'>
			     	<td class="bt_info_odd" exp="<input type='checkbox' name='selectedbox' value='{device_osapp_id}' state='{proc_status}' id='selectedbox_{device_osapp_id}' onclick='chooseOne(this)'/>" >选择</td>
					<td class="bt_info_even" autoOrder="1">序号</td>
					<td class="bt_info_odd" exp="{project_name}">项目名称</td>
					<td class="bt_info_even" exp="{device_osapp_no}">报停申请单号</td>
					<td class="bt_info_odd" exp="{osapp_name}">报停申请单名称</td>
					<td class="bt_info_even" exp="{org_name}">申请单位名称</td>
					<td class="bt_info_odd" exp="{employee_name}">经办人</td>
					<td class="bt_info_even" exp="{osappdate}">申请时间</td>
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
	<!--  		    <li id="tag3_1"><a href="#" onclick="getContentTab(this,5)">分类码</a></li>-->
			  </ul>
			</div>
			<div id="tab_box" class="tab_box">
				<div id="tab_box_content0" name="tab_box_content0" class="tab_box_content">
					<table id="projectMap" name="projectMap" border="0" cellpadding="0" cellspacing="0"  class="tab_line_height" width="100%" style="margin-top:10px;background:#efefef"> 
					<tr>
				      <td  class="inquire_item6">项目名称：</td>
				      <td  class="inquire_form6" ><input id="project_name" class="input_width" type="text" value="" disabled/>&nbsp;</td>
				      <td  class="inquire_item6">申请单名称：</td>
				      <td  class="inquire_form6"><input id="device_ospp_name" class="input_width" type="text"  value="" disabled/> &nbsp;</td>
				      <td  class="inquire_item6">&nbsp;申请单号：</td>
				      <td  class="inquire_form6"  ><input id="device_osapp_no" class="input_width" type="text"  value="" disabled/> &nbsp;</td>
				     </tr>
				    <tr >
				     <td  class="inquire_item6">申请单位名称：</td>
				     <td  class="inquire_form6"><input id="org_name" class="input_width" type="text"  value="" disabled/> &nbsp;</td> 
				     <td  class="inquire_item6">&nbsp;申请人：</td>
				     <td  class="inquire_form6"><input id="employee_name" class="input_width" type="text"  value="" disabled/> &nbsp;</td>  
				     <td  class="inquire_item6">申请时间：</td>
				     <td  class="inquire_form6"><input id="appdate" class="input_width" type="text"  value="" disabled/> &nbsp;</td> 
				    </tr>
				    <tr>
				     <td  class="inquire_item6">&nbsp;状态：</td>
				     <td  class="inquire_form6"><input id="state_desc" class="input_width" type="text"  value="" disabled/> &nbsp;</td> 
				     <td colspan='2'>&nbsp;</td>
				    </tr>
					</table>
				</div>
				<div id="tab_box_content1" name="tab_box_content1" class="tab_box_content" style="display:none">
					<table border="0" cellpadding="0" cellspacing="0"  class="tab_line_height" width="100%" style="margin-top:10px;background:#efefef"> 
						<tr>
						<td class="bt_info_even" width="4%">选择</td>
						<td class="bt_info_odd" width="11%">设备编号</td>
						<td class="bt_info_even" width="11%">设备名称</td>
						<td class="bt_info_odd" width="11%">规格型号</td>
						<td class="bt_info_even" width="8%">数量</td>
						<td class="bt_info_odd" width="11%">自编号</td>
						<td class="bt_info_even" width="11%">实物标识号</td>
						<td class="bt_info_odd" width="11%">牌照号</td>
						<td class="bt_info_even" width="11%">设备所属单位</td>
						<td class="bt_info_odd" width="11%">进队日期</td>
						<td class="bt_info_even" width="11%">报停原因</td>
						<td class="bt_info_odd" width="11%">预计报停日期</td>
						<td class="bt_info_even" width="11%">预计启动日期</td>
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
				//先进行查询
				var str = "select * from ("
				str += "select alldet.device_osdet_id,alldet.device_osapp_id,alldet.dev_name,alldet.dev_model,outorg.org_abbreviation as out_org_name,";
				str += "alldet.dev_coding,alldet.self_num,alldet.dev_sign,alldet.license_num,alldet.osnum,unitsd.coding_name as unit_name,";
				str += "alldet.reason,alldet.start_date,alldet.plan_end_date,alldet.devtype,alldet.act_in_time ";
				str += "from gms_device_osapp_detail alldet ";
				str += "left join comm_coding_sort_detail sd on alldet.dev_name=sd.coding_code_id ";
				str += "left join comm_org_subjection sub on alldet.out_org_id = sub.org_subjection_id left join comm_org_information outorg on sub.org_id = outorg.org_id ";
				str += "left join comm_coding_sort_detail unitsd on alldet.dev_unit=unitsd.coding_code_id ";
				str += "where alldet.device_osapp_id = '"+currentid+"'  and alldet.devtype='1'";
				str += "union "
				str += "select alldet.device_osdet_id,alldet.device_osapp_id,sd.coding_name as dev_name,null as dev_model,outorg.org_name as out_org_name,";
				str += "null as dev_coding,null as self_num,null as dev_sign,null as license_num,alldet.osnum,unitsd.coding_name as unit_name,";
				str += "alldet.reason,alldet.start_date,alldet.plan_end_date,alldet.devtype,alldet.act_in_time ";
				str += "from gms_device_osapp_detail alldet ";
				str += "left join comm_coding_sort_detail sd on alldet.dev_name=sd.coding_code_id ";
				str += "left join comm_org_information outorg on alldet.out_org_id=outorg.org_id ";
				str += "left join comm_coding_sort_detail unitsd on alldet.dev_unit=unitsd.coding_code_id ";
				str += "where alldet.device_osapp_id = '"+currentid+"'  and alldet.devtype='2'";
				str += ") order by devtype ";
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
			innerHTML += "<td>"+(i+1)+"</td><td>"+datas[i].dev_coding+"</td><td>"+datas[i].dev_name+"</td><td>"+datas[i].dev_model+"</td>";
			innerHTML += "<td>"+datas[i].osnum+"</td><td>"+datas[i].self_num+"</td><td>"+datas[i].dev_sign+"</td><td>"+datas[i].license_num+"</td>";
			innerHTML += "<td>"+datas[i].out_org_name+"</td><td>"+datas[i].act_in_time+"</td><td>"+datas[i].reason+"</td>";
			innerHTML += "<td>"+datas[i].start_date+"</td><td>"+datas[i].plan_end_date+"</td>";
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
	var projectCommon="<%=projectCommon%>";
	
	cruConfig.contextPath =  "<%=contextPath%>";
	cruConfig.cdtType = 'form';

$().ready(function(){

		//井中地震获取子项目的父项目编号 
		if(projectInfoNos!=null && projectType == "5000100004000000008"){
			ret = jcdpCallService("DevCommInfoSrv", "getFatherNoInfo", "projectInfoNo="+projectInfoNos);
			retFatherNo = ret.deviceappMap.project_father_no;
		}

		//井中地震子项目屏蔽新增、修改、删除、提交、编辑明细按钮
	    if(projectType == "5000100004000000008" && retFatherNo.length>=1)
	    {
	    	$(".zj").hide();
			$(".xg").hide();
			$(".sc").hide();
			$(".tj").hide();
	    }
});
	
	function clearQueryText(){
		$("#s_project_name").val("");
		$("#s_org_name").val("");
	}
	function searchDevData(){
		var v_project_name = document.getElementById("s_project_name").value;
		var v_dev_osapp_no = document.getElementById("s_dev_osapp_no").value;
		refreshData(v_project_name, v_dev_osapp_no);
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
	
    function refreshData(v_project_name,v_dev_osapp_no){
		var str = "select pro.project_name,devapp.device_osapp_id,devapp.device_osapp_no,devapp.osapp_name,devapp.project_info_no,";
			str += "devapp.osapp_org_id,devapp.os_employee_id,devapp.osappdate,devapp.create_date,devapp.modifi_date,wfmiddle.proc_status,";
			str += "case wfmiddle.proc_status when '1' then '待审批' when '3' then '审批通过' when '4' then '审批不通过' else '未提交' end as state_desc,";
			str += "org.org_abbreviation as org_name,emp.employee_name ";
			str += "from gms_device_osapp devapp  ";
			str += "left join common_busi_wf_middle wfmiddle on wfmiddle.business_id = devapp.device_osapp_id and wfmiddle.bsflag='0' ";
			str += "left join comm_org_information org on devapp.osapp_org_id = org.org_id  ";
			str += "left join comm_human_employee emp on devapp.os_employee_id = emp.employee_id ";

			//井中地震 
			if(projectType == "5000100004000000008" && retFatherNo.length >= 1){//子项目
				str += "left join gp_task_project pro on devapp.project_info_no=pro.project_info_no and pro.bsflag = '0' and pro.project_type = '5000100004000000008' ";
				str += "where devapp.bsflag = '0' and devapp.project_info_no = '" +retFatherNo+"' ";
	        }else if(projectType == "5000100004000000008" && retFatherNo.length <= 0){
	        	str += "left join gp_task_project pro on devapp.project_info_no=pro.project_info_no and pro.bsflag = '0' and pro.project_father_no is null and pro.project_type = '5000100004000000008' ";
				str += "where devapp.bsflag = '0' and devapp.project_info_no='"+projectInfoNos+"' " ;
	         }else{
	        	str += "left join gp_task_project pro on devapp.project_info_no=pro.project_info_no and pro.bsflag = '0' ";
				str += "where devapp.bsflag = '0' and devapp.project_info_no='"+projectInfoNos+"' ";
		     }

		if(v_project_name!=undefined && v_project_name!=''){
			str += "and pro.v_project_name like '%"+v_project_name+"%' ";
		}
		if(v_dev_osapp_no!=undefined && v_dev_osapp_no!=''){
			str += "and devapp.device_osapp_no like '%"+v_dev_osapp_no+"%' ";
		}
		cruConfig.queryStr = str;
		queryData(cruConfig.currentPage);
	}
    function loadDataDetail(device_osapp_id){
    	var retObj;
		if(device_osapp_id!=null){
			 retObj = jcdpCallService("DevCommInfoSrv", "getOsAppBaseInfo", "deviceosappid="+device_osapp_id);
		}else{
			var ids = getSelIds('selectedbox');
		    if(ids==''){ 
			    alert("请先选中一条记录!");
	     		return;
		    }
		    retObj = jcdpCallService("DevCommInfoSrv", "getOsAppBaseInfo", "deviceosappid="+ids);
		}
		//选中这一条checkbox
		$("#selectedbox_"+retObj.deviceappMap.device_osapp_id).attr("checked","checked");
		//取消其他选中的
		$("input[type='checkbox'][name='selectedbox'][id!='selectedbox_"+retObj.deviceappMap.device_osapp_id+"']").removeAttr("checked");
		//给数据回填
		$("#project_name","#projectMap").val(retObj.deviceappMap.project_name);
		$("#device_ospp_name","#projectMap").val(retObj.deviceappMap.osapp_name);
		$("#device_osapp_no","#projectMap").val(retObj.deviceappMap.device_osapp_no);
		$("#state_desc","#projectMap").val(retObj.deviceappMap.state_desc);
		$("#org_name","#projectMap").val(retObj.deviceappMap.org_name);
		$("#employee_name","#projectMap").val(retObj.deviceappMap.employee_name);
		$("#appdate","#projectMap").val(retObj.deviceappMap.osappdate);
		$("#createdate","#projectMap").val(retObj.deviceappMap.createdate);
		var device_ospp_name = retObj.deviceappMap.osapp_name;
		var device_osapp_no = retObj.deviceappMap.device_osapp_no;
		var curbusinesstype = "";
		if(projectType == '5000100004000000008'){//井中
			curbusinesstype = "5110000004100001066";
		}else{
			curbusinesstype = "5110000004100000045";
		}
		//重新加载当前标签页信息
		getContentTab(undefined,selectedTagIndex);
		//工作流信息
		var submitdate =getdate();
    	processNecessaryInfo={        							//流程引擎关键信息
			businessTableName:"gms_device_osapp",    			//置入流程管控的业务表的主表表明
			businessType:curbusinesstype,    				//业务类型 即为之前设置的业务大类
			businessId:device_osapp_id,           				//业务主表主键值
			businessInfo:"设备报停计划审批列表信息<报停申请单名称:"+device_ospp_name+";报停申请单号:"+device_osapp_no+">",
			applicantDate:submitdate       						//流程发起时间
		};
		processAppendInfo={ 
			projectName:projectName,										//流程引擎附加临时变量信息
			projectInfoNo:projectInfoNos,
			deviceosappid:device_osapp_id
		};
    	loadProcessHistoryInfo();
    }
	function toAddMainPlanPage(){
		if('<%=projectInfoNo%>' == 'null'){
			alert("未选择项目信息!");
			return;
		}
		popWindow('<%=contextPath%>/rm/dm/devoutservice/osNewApply.jsp?projectInfoNo=<%=projectInfoNo%>','1050:680');
	}
	function toModifyMainPlanPage(){
		var deviceosappid ;
		$("input[type='checkbox'][name='selectedbox']").each(function(){
			if(this.checked){
				deviceosappid = this.value;
			}
		});
		if(deviceosappid==undefined){
			alert("请选择修改的记录");
			return;
		}
		//判断状态如果是已提交，那么不能删除
		var str = "select devapp.device_osapp_id,nvl(wfmiddle.proc_status,'') as proc_status ";
			str += "from gms_device_osapp devapp  ";
			str += "left join common_busi_wf_middle wfmiddle on wfmiddle.business_id = devapp.device_osapp_id  ";
			str += "where devapp.bsflag = '0' and devapp.device_osapp_id='"+deviceosappid+"'";
		var unitRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+str);
		//只要不是待审批和审核通过，都可以修改
		if(unitRet.datas[0].proc_status == ''||unitRet.datas[0].proc_status == '4'){
			popWindow('<%=contextPath%>/rm/dm/devoutservice/osModifyApply.jsp?projectInfoNo=<%=projectInfoNo%>&deviceosappid='+deviceosappid,'960:680');
		}else{
			alert("本单据已提交，不能修改!");
			return;
		}
	}
	function toDelPlanPage(){
		var deviceosappid ;
		$("input[type='checkbox'][name='selectedbox']").each(function(){
			if(this.checked){
				deviceosappid = this.value;
			}
		});
		if(deviceosappid==undefined){
			alert("请选择修改的记录");
			return;
		}
		//判断状态如果是已提交，那么不能删除
		var str = "select devapp.device_osapp_id,nvl(wfmiddle.proc_status,'') as proc_status ";
			str += "from gms_device_osapp devapp  ";
			str += "left join common_busi_wf_middle wfmiddle on wfmiddle.business_id = devapp.device_osapp_id  ";
			str += "where devapp.bsflag = '0' and devapp.device_osapp_id='"+deviceosappid+"'";
		var unitRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+str);
		//什么状态不能删除，和业务专家确定
		if(unitRet.datas[0].state == ''||unitRet.datas[0].state == '4'){
			if(confirm("是否执行删除操作?")){
				var sql = "update gms_device_osapp set bsflag='1' where device_osapp_id='"+deviceosappid+"'";
				var path = cruConfig.contextPath+"/rad/asyncDelete.srq";
				var params = "deleteSql="+sql;
				params += "&ids=";
				var retObject = syncRequest('Post',path,params);
				refreshData();
			}
		}else{
			alert("本单据已提交，不能删除!");
			return;
		}
	}
	//提交操作 待修改
	function toSumbitDevApp(){
		var deviceosappid ;
		$("input[type='checkbox'][name='selectedbox']").each(function(){
			if(this.checked){
				deviceosappid = this.value;
			}
		});
		//判断状态如果是已提交，那么不能删除
		var str = "select devapp.device_osapp_id,nvl(wfmiddle.proc_status,'') as proc_status ";
			str += "from gms_device_osapp devapp  ";
			str += "left join common_busi_wf_middle wfmiddle on wfmiddle.business_id = devapp.device_osapp_id  ";
			str += "where devapp.bsflag = '0' and devapp.device_osapp_id='"+deviceosappid+"'";
		var unitRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+str);
		//什么状态不能删除，和业务专家确定
		if(unitRet.datas[0].proc_status == '' || unitRet.datas[0].proc_status == '4'){
			//判断是否添加了子记录，如果没添加，提示错误
			var deviceallappid ;
			$("input[type='checkbox'][name='selectedbox']").each(function(){
				if(this.checked){
					deviceallappid = this.value;
				}
			});
			if (!window.confirm("确认要提交吗?")) {
				return;
			}
			submitProcessInfo();
			refreshData();
			alert('提交成功！');
		}
	}
	
    //chooseOne()函式，參數為觸發該函式的元素本身   
    function chooseOne(cb){
        var obj = document.getElementsByName("rdo_entity_id");   
        for (i=0; i<obj.length; i++){   
            if (obj[i]!=cb) obj[i].checked = false;   
            else obj[i].checked = true;   
        }   
    }   

</script>
</html>
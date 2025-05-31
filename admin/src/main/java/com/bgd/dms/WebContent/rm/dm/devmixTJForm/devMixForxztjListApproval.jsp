<%@ page contentType="text/html;charset=utf-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%@taglib uri="wf" prefix="wf"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String projectInfoNo = user.getProjectInfoNo();
	String projectType = request.getParameter("projectType")==null?user.getProjectType():request.getParameter("projectType");
	String projectCommon = user.getProjectCommon();
	String userSubId = user.getOrgSubjectionId();
	String orgId = user.getSubOrgIDofAffordOrg();
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

  <title>多项目-闲置设备调剂</title> 
 </head> 
 
 <body style="background:#fff" onload="refreshData()">
      	<div id="list_table">
			<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td class="ali_cdn_name">调剂单名称</td>
			    <td class="ali_cdn_input">
			    <input id="s_device_app_name" name="s_device_app_name" type="text" />
			     <input type='hidden' id="szButton" name="szButton" value=""/>
			    </td>
			    <td class="ali_cdn_name">调剂单号</td>
			    <td class="ali_cdn_input"><input id="s_mixinfo_no" name="s_mixinfo_no" type="text" /></td>
			    <td class="ali_cdn_name">状态</td>
			    <td class="ali_cdn_input">
			    	<select id="s_opr_state_desc" name="s_opr_state_desc" class="select_width" >
						<option value="0">未处理</option>
						<option value="1">已处理</option>
			    	</select>
			    </td>
			    <td class="ali_query">
				    <span class="cx"><a href="#" onclick="searchDevData()" title="查询"></a></span>
			    </td>
			    <td class="ali_query">
				    <span class="qc"><a href="#" onclick="clearQueryText()" title="清除"></a></span>
			    </td>
			    <td>&nbsp;</td>
			    <td class='ali_btn'><span class='dk'><a href='#' onclick='toSumbitMixApp()'  title='审批'></a></span></td>
			  </tr>
			</table>
			</td>
			    <td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
			  </tr>
			</table>
			</div>
			<div id="table_box">
			  <table style="width:98.5%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">		
			     <tr id='device_mixinfo_id_{device_mixinfo_id}' name='device_mixinfo_id'>
				<td class="bt_info_even" exp="<input type='checkbox' name='selectedbox' mixstate='{state}' value='{device_mixinfo_id}' id='selectedbox_{device_mixinfo_id}' />" >选择</td>
					<td class="bt_info_odd" autoOrder="1">序号</td>
					<td class="bt_info_even" exp="{mixinfo_name}">申请单名称</td>
					<td class="bt_info_odd" exp="{mixinfo_no}">调剂单号</td>
					<td class="bt_info_even" exp="{inorgname}">转入单位</td>
					<td class="bt_info_even" exp="{outorgname}">转出(调剂)单位</td>
					<td class="bt_info_even" exp="{project_name}">项目名称</td>
					<td class="bt_info_odd" exp="{user_name}">开据人</td>
					<td class="bt_info_even" exp="{create_date}">调配时间</td>
					<td class="bt_info_odd" exp="{state}">状态</td>
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
			       <li id="tag3_2"><a href="#" onclick="getContentTab(this,2)">审批流程</a></li>
			    <li id="tag3_3"><a href="#" onclick="getContentTab(this,3)">附件</a></li>
			    <li id="tag3_4"><a href="#" onclick="getContentTab(this,4)">备注</a></li>
			    <li id="tag3_5"><a href="#" onclick="getContentTab(this,5)">分类码</a></li>
			  </ul>
			</div>
			<div id="tab_box" class="tab_box">
				<div id="tab_box_content0" name="tab_box_content0" class="tab_box_content">
					<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
			  <tr>
				<td class="inquire_item6">项目名称</td>
				<td class="inquire_form6"><input id="dev_project_name" name="" class="input_width" type="text" /></td>
				<td class="inquire_item6">调拨单号</td>
				<td class="inquire_form6"><input id="dev_mixinfo_no" name="" class="input_width" type="text" /></td>
				<td class="inquire_item6">调拨单名称</td>
				<td class="inquire_form6"><input id="dev_mixinfo_name" name="" class="input_width" type="text" /></td>
				
			  </tr>
				<tr>
				<td class="inquire_item6">转入单位</td>
				<td class="inquire_form6"><input id="dev_in_org" name="" class="input_width" type="text" /></td>
				<td class="inquire_item6">转出单位</td>
				<td class="inquire_form6"><input id="dev_out_org" name="" class="input_width" type="text" /></td>
				<td class="inquire_item6">开据人</td>
				<td class="inquire_form6"><input id="dev_print_emp" name="" class="input_width" type="text" /></td>
			  </tr>
				<tr>
				<td class="inquire_item6">调配时间</td>
				<td class="inquire_form6"><input id="dev_create_date" name="" class="input_width" type="text" /></td>
				<td class="inquire_item6">处理状态</td>
				<td class="inquire_form6"><input id="dev_state" name="" class="input_width" type="text" /></td>
			  </tr>
			</table>
				</div>
				
				
				<div id="tab_box_content1" name="tab_box_content1" idinfo="" class="tab_box_content" style="display:none">
					<table border="0" cellpadding="0" cellspacing="0"  class="tab_line_height" width="100%" style="margin-top:10px;background:#efefef"> 
						<tr class="bt_info">
				    		<td class="bt_info_even" width="5%">序号</td>
				        	<td class="bt_info_odd" width="15%">ERP设备编号</td>
							<td class="bt_info_even" width="11%">设备名称</td>
							<td class="bt_info_odd" width="11%">规格型号</td>
							<td class="bt_info_even" width="10%">自编号</td>
							<td class="bt_info_odd" width="9%">牌照号</td>
							<td class="bt_info_even" width="11%">实物标识号</td>
							<td class="bt_info_odd" width="13%">计划进场时间</td>
							<td class="bt_info_even" width="13%">计划离场时间</td>
				        </tr>
				        <tbody id="detailMap" name="detailMap" ></tbody>
					</table>
				</div>
				
				<div id="tab_box_content2" name="tab_box_content2" idinfo="" class="tab_box_content" style="display:none">
					<table border="0" cellpadding="0" cellspacing="0"  class="tab_line_height" width="100%" style="margin-top:10px;background:#efefef"> 
						<tr class="bt_info">
				    		<td class="bt_info_even" width="5%">序号</td>
				        	<td class="bt_info_odd" width="15%">审批环节</td>
							<td class="bt_info_even" width="11%">审批人</td>
							<td class="bt_info_odd" width="11%">审批意见</td>
							<td class="bt_info_even" width="10%">审批时间</td>
							<td class="bt_info_odd" width="9%">审批情况</td>
				        </tr>
				        <tbody id="shenpiMap" name="shenpiMap" ></tbody>
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
				currentid = currentid.split("~")[0];
			}
		});
		if(index == 1){
			//动态查询明细
			var idinfo = $(filterobj).attr("idinfo");
			if(currentid != undefined && idinfo == currentid){
				//已经有值，且完成钻取，那么不再钻取
			}else{
				//先进行查询
				
		var str = " select d.dev_plan_start_date,d.dev_plan_end_date,account.dev_coding,account.dev_name,account.dev_model,account.dev_sign,account.self_num,account.license_num from GMS_DEVICE_APPMIX_DETAIL d  ";
			str+= " left join gms_device_account account on account.dev_acc_id=d.dev_acc_id ";
			str+= " left join GMS_DEVICE_MIXINFO_FORM f on f.device_mixinfo_id=d.device_mix_subid ";
			str+= "where f.device_mixinfo_id='"+currentid+"'";
				var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+str+'&pageSize=10000');
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
		if(index == 2){
			//动态查询明细
			var idinfo = $(filterobj).attr("idinfo");
			if(currentid != undefined && idinfo == currentid){
				//已经有值，且完成钻取，那么不再钻取
			}else{
				//先进行查询
				
		var str = "  select '物探处审批' as wutanchu, to_char(f.wapproval_date,'yyyy-mm-dd') as wdate,f.wapproval_desc,(select  u.user_name from p_auth_user u where u.user_id=f.wapprovaler ) as username ,(case when f.state='2' then '待审批'  when f.state='4' then '审批通过' when  f.state='1' then '审批通过' when f.state='3'  then '审批不通过' end) as state  from GMS_DEVICE_MIXINFO_FORM f ";
			str+= " where f.device_mixinfo_id = '"+currentid+"' union all ";
			str+= " select '设备物资处审批' as wutanchu, to_char(f.approval_date,'yyyy-mm-dd') as wdate,f.approval_desc as wapproval_desc,(select  u.user_name from p_auth_user u where u.user_id=f.approvaler ) as username , (case when f.state='4' then '待审批'  when  f.state='1' then '审批通过' when f.state='3'  then '审批不通过' end) as state  from GMS_DEVICE_MIXINFO_FORM f ";
			str+= "where f.device_mixinfo_id = '"+currentid+"'";
				var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+str+'&pageSize=10000');
				basedatas = queryRet.datas;
				if(basedatas!=undefined && basedatas.length>=1){
					//先清空
					var filtermapid = "#shenpiMap";
					$(filtermapid).empty();
					appendDataToDetailTabshenpi(filtermapid,basedatas);
					//设置当前标签页显示的主键
					$(filterobj).attr("idinfo",currentid);
				}else{
					var filtermapid = "#shenpiMap";
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
			innerHTML += "<td>"+(i+1)+"</td><td>"+datas[i].dev_coding+"</td><td>"+datas[i].dev_name+"</td>";
			innerHTML += "<td>"+datas[i].dev_model+"</td><td>"+datas[i].self_num+"</td><td>"+datas[i].license_num+"</td>";
			innerHTML += "<td>"+datas[i].dev_sign+"</td><td>"+datas[i].dev_plan_start_date+"</td><td>"+datas[i].dev_plan_end_date+"</td>";
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

	cruConfig.contextPath =  "<%=contextPath%>";
	cruConfig.cdtType = 'form';
	var projectInfoNos = '<%=projectInfoNo%>';
	var projectType="<%=projectType%>";

	var ret;
	var retFatherNo;
	var sonFlag = null;//是否为子项目标志
	
	
	function searchDevData(){
		var v_opr_state_desc = document.getElementById("s_opr_state_desc").value;
		var v_device_app_name = document.getElementById("s_device_app_name").value;
		var v_mixinfo_no = document.getElementById("s_mixinfo_no").value;
		refreshData(v_device_app_name, v_mixinfo_no,v_opr_state_desc);
	}
	//清空查询条件
    function clearQueryText(){
    	document.getElementById("s_opr_state_desc").value="";
    	document.getElementById("s_device_app_name").value="";
		document.getElementById("s_mixinfo_no").value="";
    }
	function refreshData(v_device_app_name,v_mixinfo_no,v_opr_state_desc){
 	var userSubId='<%=userSubId%>';
 	var str='';
 	if(userSubId.indexOf("C105001")>1||userSubId.indexOf("C105005")>1)
 	{
 		userSubId=userSubId.substr(0,10);
 	}
 	else
 	{
 		userSubId=userSubId.substr(0,7);
 	}
 if(userSubId=='C105029')
 {
 	str += " select f.device_mixinfo_id,f.mixinfo_no,f.mixinfo_name, inorg.org_abbreviation as inorgname,outorg.org_abbreviation as outorgname,f.create_date,p.project_name,(case when f.state ='1' then '审批通过' when f.state='4' then  '待审批'  when f.state='3' then  '审批不通过' end) as state,puser.user_name from GMS_DEVICE_MIXINFO_FORM f ";
			str+= " left join (comm_org_subjection sub left join comm_org_information inorg on sub.org_id=inorg.org_id )  on f.in_org_id = sub.org_subjection_id ";
			str+= " left join (comm_org_subjection sub left join comm_org_information outorg on sub.org_id=outorg.org_id )  on f.out_org_id = sub.org_subjection_id ";
			str+= " left join gp_task_project p on p.project_info_no=f.project_info_no";  
			str+=" left join p_auth_user puser on puser.user_id=f.creator_id "
			str+= " where f.mixform_type='6' and  f.bsflag='0'  and f.state!='0' and f.state!='2' and f.state!='3' and f.WAPPROVAL_DATE is not null   and f.out_org_id like '<%=orgId%>%' ";
		if(v_device_app_name!=undefined && v_device_app_name!=''){
			str += "and f.mixinfo_name like '%"+v_device_app_name+"%' ";
		}
		if(v_mixinfo_no!=undefined && v_mixinfo_no!=''){
			str += "and f.mixinfo_no like '%"+v_mixinfo_no+"%' ";
		}
		if(v_opr_state_desc==undefined|| v_opr_state_desc=='')
			{
			 v_opr_state_desc='0';
			}
		if(v_opr_state_desc!=undefined && v_opr_state_desc!=''){
			if(v_opr_state_desc=='0')
			{
			str += "and f.state='4' ";
			}
			if(v_opr_state_desc=='1')
			{
			str += "and ( f.state='3' or f.state='1' )";
			}
		}
		str += " union all select f.device_mixinfo_id,f.mixinfo_no,f.mixinfo_name, inorg.org_abbreviation as inorgname,outorg.org_abbreviation as outorgname,f.create_date,p.project_name,(case when f.state ='1' then '审批通过' when f.state='4' then  '待审批'  when f.state='3' then  '审批不通过'  end) as state,puser.user_name from GMS_DEVICE_MIXINFO_FORM f ";
			str+= " left join (comm_org_subjection sub left join comm_org_information inorg on sub.org_id=inorg.org_id )  on f.in_org_id = sub.org_subjection_id ";
			str+= " left join (comm_org_subjection sub left join comm_org_information outorg on sub.org_id=outorg.org_id )  on f.out_org_id = sub.org_subjection_id ";
			str+= " left join gp_task_project p on p.project_info_no=f.project_info_no";  
			str+=" left join p_auth_user puser on puser.user_id=f.creator_id "
			str+= " where f.mixform_type='6' and  f.bsflag='0'  and f.state='3'  and f.WAPPROVAL_DATE is not null and  f.APPROVAL_DATE is not null   and f.out_org_id like '<%=orgId%>%' ";		
 		if(v_device_app_name!=undefined && v_device_app_name!=''){
			str += "and f.mixinfo_name like '%"+v_device_app_name+"%' ";
		}
		if(v_mixinfo_no!=undefined && v_mixinfo_no!=''){
			str += "and f.mixinfo_no like '%"+v_mixinfo_no+"%' ";
		}
		if(v_opr_state_desc==undefined|| v_opr_state_desc=='')
		{
		 v_opr_state_desc='0';
		}
		if(v_opr_state_desc!=undefined && v_opr_state_desc!=''){
			if(v_opr_state_desc=='0')
			{
			str += "and f.state='4' ";
			}
			if(v_opr_state_desc=='1')
			{
			str += "and ( f.state='3' or f.state='1' )";
			}
		}
 }
 else
 {
 		str += " select f.device_mixinfo_id,f.mixinfo_no,f.mixinfo_name, inorg.org_abbreviation as inorgname,outorg.org_abbreviation as outorgname,f.create_date,p.project_name,(case when f.state ='1' then '审批通过' when f.state='4' then  '审批通过'  when f.state='3' then  '审批不通过' when f.state='2' then  '待审批'  end) as state,puser.user_name from GMS_DEVICE_MIXINFO_FORM f ";
			str+= " left join (comm_org_subjection sub left join comm_org_information inorg on sub.org_id=inorg.org_id )  on f.in_org_id = sub.org_subjection_id ";
			str+= " left join (comm_org_subjection sub left join comm_org_information outorg on sub.org_id=outorg.org_id )  on f.out_org_id = sub.org_subjection_id ";
			str+= " left join gp_task_project p on p.project_info_no=f.project_info_no";  
			str+=" left join p_auth_user puser on puser.user_id=f.creator_id "
			str+= " where f.mixform_type='6' and  f.bsflag='0'  and f.state!='0' and f.out_org_id like '<%=orgId%>%' ";
		if(v_device_app_name!=undefined && v_device_app_name!=''){
			str += "and f.mixinfo_name like '%"+v_device_app_name+"%' ";
		}
		if(v_mixinfo_no!=undefined && v_mixinfo_no!=''){
			str += "and f.mixinfo_no like '%"+v_mixinfo_no+"%' ";
		}
		if(v_opr_state_desc==undefined|| v_opr_state_desc=='')
		{
		 v_opr_state_desc='0';
		}
		if(v_opr_state_desc!=undefined && v_opr_state_desc!=''){
			if(v_opr_state_desc=='0')
			{
			str += "and f.state='2' ";
			}
			if(v_opr_state_desc=='1')
			{
			str += "and ( f.state='3' or f.state='1' or f.state='4' )";
			}
		}
		}
	str+="  order by f.create_date desc ";
		cruConfig.queryStr = str;
		queryData(cruConfig.currentPage);
	}
	
	var selectedTagIndex = 0;
	var showTabBox = document.getElementById("tab_box_content0");
	
    function chooseOne(cb){   
        var obj = document.getElementsByName("selectedbox");   
        for (i=0; i<obj.length; i++){   
            if (obj[i]!=cb) obj[i].checked = false;   
            else obj[i].checked = true;   
        }   
    }   

    function loadDataDetail(shuaId){
    	var retObj;
		if(shuaId!=null){
			shuaId = shuaId.split("~")[0];
			retObj = jcdpCallService("DevInsSrv", "getXzDeviceInfo", "devrecId="+shuaId);
		}else{
			var ids = getSelIds('selectedbox');
		    if(ids==''){ 
			    alert("请先选中一条记录!");
	     		return;
		    }
		    ids = ids.split("~")[0];
		    retObj = jcdpCallService("DevInsSrv", "getXzDeviceInfo", "devrecId="+ids);
		}
		//取消其他选中的
			$("input[type='checkbox'][name='selectedbox'][id!='selectedbox_"+retObj.deviceaccMap.device_mixinfo_id+"']").removeAttr("checked");
			//选中这一条checkbox
			$("input[type='checkbox'][name='selectedbox'][id='selectedbox_"+retObj.deviceaccMap.device_mixinfo_id+"']").attr("checked",'true');
			var result = '';
			$("input[type='checkbox'][name='selectedbox']").each(function(){
				if(this.checked){
					 result = this.mixstate;
				}
			});
			document.getElementById("dev_project_name").value =retObj.deviceaccMap.project_name;
		document.getElementById("dev_mixinfo_no").value =retObj.deviceaccMap.mixinfo_no;
		document.getElementById("dev_mixinfo_name").value =retObj.deviceaccMap.mixinfo_name;
		document.getElementById("dev_in_org").value =retObj.deviceaccMap.inorgname;
		document.getElementById("dev_out_org").value =retObj.deviceaccMap.outorgname;
		document.getElementById("dev_print_emp").value =retObj.deviceaccMap.user_name;
		document.getElementById("dev_create_date").value =retObj.deviceaccMap.create_date;
		document.getElementById("dev_state").value =result;
		//重新加载当前标签页信息
		getContentTab(undefined,selectedTagIndex);
    }
    
    function toAddMixPlanPage()
    {
    	popWindow('<%=contextPath%>/rm/dm/devmixTJForm/devMixForxztjNewApply.jsp','950:680');
    	
    }
    function toModifyMixPlanPage()
    {
    	
    var result='0';
    $("input[type='checkbox'][name='selectedbox']").each(function(){
			if(this.checked){
				var mixstate = this.mixstate;
				if(mixstate!='未提交'){
				alert("已提交的调剂单不能修改!");
				result='1';
				return;
				}
			}
		});
		if(result=='1')
		{
		return;
		}
    var ids = getSelIds('selectedbox');
    	popWindow('<%=contextPath%>/rm/dm/devmixTJForm/devMixForxztjNewApply.jsp?mixId='+ids,'950:680');
    }
    
    function toDelMixPlanPage()
    {
    var result='0';
		$("input[type='checkbox'][name='selectedbox']").each(function(){
			if(this.checked){
				var mixstate = this.mixstate;
				if(mixstate!='未提交'){
				alert("已提交的调剂单不能删除!");
				result='1';
				}
			}
		});
		if(result=='1')
		{
		return;
		}
		if(confirm("是否执行删除操作?")){
		var ids = getSelIds('selectedbox');
			var sql = "update gms_device_mixinfo_form set bsflag='1' where device_mixinfo_id ='"+ids+"'";
			var path = cruConfig.contextPath+"/rad/asyncDelete.srq";
			var params = "deleteSql="+sql;
			params += "&ids=";
			var retObject = syncRequest('Post',path,params);
			var sql2 = "update gms_device_account t set t.saveflag='0' where t.dev_acc_id in( select d.dev_acc_id  from GMS_DEVICE_APPMIX_DETAIL d  where d.device_mix_subid='"+ids+"')";
			var path2 = cruConfig.contextPath+"/rad/asyncDelete.srq";
			var params2 = "deleteSql="+sql2;
			params2 += "&ids=";
			var retObject1 = syncRequest('Post',path2,params2);
			refreshData();
		}
		
    
    }
    
    
   function toSumbitMixApp()
   {
	   var ids = getSelIds('selectedbox');
	    if(ids==''){ 
		    alert("请先选中一条记录!");
    		return;
	    }
	   var result='0';
		$("input[type='checkbox'][name='selectedbox']").each(function(){
			if(this.checked){
				var mixstate = this.mixstate;
				if(mixstate=='审批通过'||mixstate=='审批不通过'){
				alert("调剂单已处理!");
				result='1';
				}
			}
		});
		if(result=='1')
		{
		return;
		}
       	popWindow('<%=contextPath%>/rm/dm/devmixTJForm/devMixForxztjApproval.jsp?mixId='+ids,'950:680');
   }
   function appendDataToDetailTabshenpi(filterobj,datas){
		for(var i=0;i<basedatas.length;i++){
			var innerHTML = "<tr>";
			innerHTML += "<td>"+(i+1)+"</td><td>"+datas[i].wutanchu+"</td><td>"+datas[i].username+"</td>";
			innerHTML += "<td>"+datas[i].wapproval_desc+"</td><td>"+datas[i].wdate+"</td><td>"+datas[i].state+"</td>";
			innerHTML += "</tr>";
			$(filterobj).append(innerHTML);
		}
		$(filterobj+">tr:odd>td:odd").addClass("odd_odd");
		$(filterobj+">tr:odd>td:even").addClass("odd_even");
		$(filterobj+">tr:even>td:odd").addClass("even_odd");
		$(filterobj+">tr:even>td:even").addClass("even_even");
	}
	
</script>
</html>
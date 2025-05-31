<%@ page contentType="text/html;charset=utf-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.bgp.gms.service.rm.dm.constants.DevConstants"%>
<%@page import="java.util.ResourceBundle"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String project_info_no = user.getProjectInfoNo();
	String orgId= user.getOrgId();
	String subid = user.getOrgSubjectionId();
	String orgsubid = user.getSubOrgIDofAffordOrg();
	
	String orgType="";
	String dgYS="";//运输设备显示设备
	String dgOrg="C6000000000039,C6000000000040,C6000000005269,C6000000005280,C6000000005275,C6000000005279,C6000000005278,C6000000007366";
	//大港8个服务中心判断标志
	if(dgOrg.contains(orgId)){
		orgType="Y";
		if(orgId.contains("C6000000005280") || orgId.contains("C6000000005279")){
			dgYS="Y";
		}
	}else{
		orgType="N";
	}	
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

  <title>大港自有设备调配单列表</title> 
 </head> 
 
 <body style="background:#fff" onload="refreshData()">
      	<div id="list_table">
			<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td class="ali_cdn_name">项目名称</td>
			    <td class="ali_cdn_input"><input id="s_project_name" name="s_project_name" type="text" /></td>
			    <td class="ali_cdn_name">申请单名称</td>
			    <td class="ali_cdn_input"><input id="s_appinfo_name" name="s_appinfo_name" type="text" /></td>
			    <td class="ali_cdn_name">调配申请单号</td>
			    <td class="ali_cdn_input"><input id="s_appinfo_no" name="s_appinfo_no" type="text" /></td>
			    <!-- <td class="ali_cdn_name">调配单号</td>
			    <td class="ali_cdn_input"><input id="s_mixinfo_no" name="s_mixinfo_no" type="text" /></td>  -->
			    <td class="ali_cdn_name">申请处理状态</td>  
			    <td class="ali_cdn_input">
			    	<select id="s_opr_state_desc" name="s_opr_state_desc" class="select_width" >
			    	    <option value="" selected="selected">--请选择--</option>						
						<option value="未分配">未分配</option>
						<option value="分配中">分配中</option> 
						<option value="已分配">已分配</option>
			    	</select>
			    </td>
			 
			    <td class="ali_query">
				    <span class="cx"><a href="#" onclick="searchDevData()" title="查询"></a></span>
			    </td>
			    <td class="ali_query">
				    <span class="qc"><a href="#" onclick="clearQueryText()" title="清除"></a></span>
			    </td>
			    <td>&nbsp;</td>
			    <auth:ListButton functionId="" css="zj" event="onclick='toAddDetailPage()'" title="调配"></auth:ListButton>
			    <auth:ListButton functionId="" css="dc" event="onclick='exportDataDoc()'" title="打印调配单"></auth:ListButton>
			  </tr>
			</table>
			</td>
			    <td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
			  </tr>
			</table>
			</div>
			<div id="table_box">
			  <table style="width:98.5%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">	<!-- {device_app_id}~{mix_state_desc}~{allapp_type}	 -->
			     <tr id='device_mixinfo_id_{device_mixinfo_id}' name='device_mixinfo_id'>
			     	<td class="bt_info_even" exp="<input type='checkbox' name='selectedbox' mixstate='{state}' value='{device_mixinfo_id}~{device_app_id}~{allapp_type}' id='selectedbox_{device_mixinfo_id}~{device_app_id}' />" >选择</td>
					<td class="bt_info_odd" autoOrder="1">序号</td>
					<td class="bt_info_even" exp="{project_name}">项目名称</td>
					<td class="bt_info_odd" exp="{device_app_name}">调配申请单名称</td>
					<td class="bt_info_even" exp="{device_app_no}">调配申请单号</td>
					<td class="bt_info_odd" exp="{app_org_name}">申请单位名称</td>
					<td class="bt_info_even" exp="{appdate}">申请时间</td>
					<td class="bt_info_odd" exp="{mix_state_desc}">调配状态</td>
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
			    <!-- 如果是服务中心隐藏 -->
			    <%if(orgType.equals("N")){ %>
			    <li id="tag3_2" ><a href="#" onclick="getContentTab(this,2)">单据调配状态</a></li>
			    <%} %>
			     <li id="tag3_3" ><a href="#" onclick="getContentTab(this,3)">调配单记录</a></li>
			  </ul>
			</div>
			<div id="tab_box" class="tab_box">
				<div id="tab_box_content0" name="tab_box_content0" class="tab_box_content">
					<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
					  <tr>
						<td class="inquire_item6">项目名称</td>
						<td class="inquire_form6"><input id="project_name" name="" class="input_width" type="text" /></td>
						<td class="inquire_item6">调配申请单号</td>
						<td class="inquire_form6"><input id="device_app_no" name="" class="input_width" type="text" /></td>
						<td class="inquire_item6">调配申请单名称</td>
						<td class="inquire_form6"><input id="device_app_name" name="" class="input_width" type="text" /></td>
					  </tr>
					  <tr>
						<td class="inquire_item6">申请单位名称</td>
						<td class="inquire_form6"><input id="app_org_name" name="" class="input_width" type="text" /></td>
						<td class="inquire_item6">申请时间</td>
						<td class="inquire_form6"><input id="appdate" name="" class="input_width" type="text" /></td>
						<!-- <td class="inquire_item6">调配状态</td>
						<td class="inquire_form6"><input id="mix_state_desc" name="" class="input_width" type="text" /></td> -->						
					  </tr>
					 <!--  <tr>
						<td class="inquire_item6">调配单号</td>
						<td class="inquire_form6"><input id="mixinfo_no" name="" class="input_width" type="text" /></td>
						<td class="inquire_item6">调配人</td>
						<td class="inquire_form6"><input id="employee_name" name="" class="input_width" type="text" /></td>
						<td class="inquire_item6">调配时间</td>
						<td class="inquire_form6"><input id="mix_date" name="" class="input_width" type="text" /></td>
					  </tr> -->
					</table>
				</div>
				<div id="tab_box_content1" name="tab_box_content1" idinfo="" class="tab_box_content" style="display:none">
					<table border="0" cellpadding="0" cellspacing="0"  class="tab_line_height" width="100%" style="margin-top:10px;background:#efefef"> 
						<tr class="bt_info">
				    		<td class="bt_info_odd" width="5%">序号</td>
							<td class="bt_info_even" width="11%">调配类别</td>
							<td class="bt_info_odd" width="11%">设备名称</td>
							<% if(dgYS.equals("Y")){ %>
								<td class="bt_info_even" width="10%">牌照号</td>
								<td class="bt_info_odd" width="10%">自编号</td>
							<% }%>
							<td class="bt_info_odd" width="10%">规格型号</td>
							<td class="bt_info_even" width="13%">调配数量</td>
							
				        </tr>
				        <tbody id="detailList" name="detailList" ></tbody>
					</table>
				</div>
				<div id="tab_box_content2" name="tab_box_content2" class="tab_box_content" style="display:none">
					<table border="0" cellpadding="0" cellspacing="0"  class="tab_line_height" width="100%" style="margin-top:10px;background:#efefef"> 
						<tr class="bt_info">
				    		<td class="bt_info_odd">序号</td>
							<td class="bt_info_even">分中心名称</td>
							<td class="bt_info_odd">调配状态</td>
				        </tr>
				        <tbody id="tpList" name="tpList" ></tbody>
					</table>
				</div>
			<div id="tab_box_content3" name="tab_box_content3" class="tab_box_content" style="display:none">
					<table border="0" cellpadding="0" cellspacing="0"  class="tab_line_height" width="100%" style="margin-top:10px;background:#efefef"> 
						<tr class="bt_info">
				    		<td class="bt_info_odd">序号</td>
							<td class="bt_info_even">调配单号</td>
							<td class="bt_info_odd">出库单位</td>
							<td class="bt_info_odd">调配日期</td>							
				        </tr>
				        <tbody id="logList" name="logList" ></tbody>
					</table>
				</div>

		 </div>
</div>
</body>
<script type="text/javascript">
var dgys = '<%=dgYS%>';

function searchDevData(){
	var v_project_name= $("#s_project_name").val();
	var v_appinfo_no = $("#s_appinfo_no").val();
	var v_appinfo_name = $("#s_appinfo_name").val();
	var v_opr_state_desc = $("#s_opr_state_desc").val();
 
	refreshData(v_project_name,v_appinfo_no,v_appinfo_name,v_opr_state_desc);	
}
//清空查询条件
function clearQueryText(){
	document.getElementById("s_project_name").value="";
	document.getElementById("s_appinfo_no").value="";
	document.getElementById("s_appinfo_name").value="";
	document.getElementById("s_opr_state_desc").value="";
}
cruConfig.contextPath =  "<%=contextPath%>";
cruConfig.cdtType = 'form';

function refreshData(v_project_name,v_appinfo_no,v_appinfo_name,v_opr_state_desc){ 
var strbase="";

	if('<%=orgType%>'=='Y'){
		 strbase="select * from (select '' as device_mixinfo_id,tt1.allapp_type,tt1.device_app_id,tt1.project_name,tt1.device_app_name,tt1.device_app_no,tt1.app_org_name,tt1.appdate,case  when tt3.assign_num=0 then '未分配' when tt2.apply_num-tt3.assign_num=0 then '已分配' when  tt2.apply_num-tt3.assign_num>0 then '分配中'else ''  end as mix_state_desc from ("
			+"SELECT app.*,pro.PROJECT_NAME,org.ORG_ABBREVIATION AS app_org_name,allapp.ALLAPP_TYPE   "
			+"FROM gms_device_app app "
			+"LEFT JOIN GP_TASK_PROJECT pro ON app.PROJECT_INFO_NO=pro.PROJECT_INFO_NO "
			+"LEFT JOIN COMM_ORG_INFORMATION org ON app.ORG_ID=org.ORG_ID   left join GMS_DEVICE_ALLAPP allapp on allapp.DEVICE_ALLAPP_ID=app.DEVICE_ALLAPP_ID  "
			+"WHERE  app.BSFLAG='0' and (allapp.ALLAPP_TYPE='S0000' or allapp.ALLAPP_TYPE='S14050208') and app.DEVICE_APP_ID IN(SELECT DISTINCT detail.DEVICE_APP_ID FROM gms_device_app_detail detail WHERE detail.BSFLAG='0' and detail.DEV_OUT_ORG_ID='<%=orgId%>')"
			+") tt1 left join ("
			+" select appdet.DEVICE_APP_ID, sum(appdet.APPLY_NUM) as apply_num from GMS_DEVICE_APP_DETAIL appdet where appdet.BSFLAG='0' and appdet.DEV_OUT_ORG_ID='<%=orgId%>' group by appdet.DEVICE_APP_ID "
			+") tt2 on tt1.DEVICE_APP_ID=tt2.DEVICE_APP_ID "
			+"left join ("
			+"select  device_app_id,case when sum(t2.assign_num) is null then 0  else sum(t2.assign_num)  end assign_num from GMS_DEVICE_APP_DETAIL t1 left join (select DEVICE_APP_DETID,  sum(ASSIGN_NUM) as assign_num from GMS_DEVICE_APPMIX_MAIN where BSFLAG = '0' group by DEVICE_APP_DETID) t2 on t1.DEVICE_APP_DETID = t2.DEVICE_APP_DETID where t1.BSFLAG = '0' and t1.DEV_OUT_ORG_ID =  '<%=orgId%>' group by device_app_id"
			+") tt3 on tt1.DEVICE_APP_ID=tt3.DEVICE_APP_ID "
		    +"union "
		    +"select cmf.device_mixinfo_id,collallapp.allapp_type,collapp.device_app_id,tp.project_name,collapp.device_app_name,collapp.device_app_no,inorg.org_abbreviation as app_org_name,collapp.appdate,"
		    +"case cmf.opr_state when '1' then '分配中' when '9' then '已分配' else '未分配' end as mix_state_desc from gms_device_collmix_form cmf left join gms_device_collapp collapp "
		    +"on cmf.device_app_id = collapp.device_app_id left join gms_device_allapp collallapp on collapp.device_allapp_id = collallapp.device_allapp_id left join gp_task_project tp "
		    +"on cmf.project_info_no = tp.project_info_no left join comm_org_information inorg on cmf.in_org_id = inorg.org_id left join comm_org_information outorg on cmf.out_org_id = outorg.org_id "
		    +"left join gms_device_coll_outform cof on cof.device_mixinfo_id = cmf.device_mixinfo_id left join comm_human_employee he on cof.print_emp_id = he.employee_id left join comm_org_subjection orgsub "
		    +"on cmf.out_org_id = orgsub.org_id and orgsub.bsflag = '0' where cmf.state = '9' and cmf.bsflag = '0' and collallapp.allapp_type = 'S9997' and (cof.devouttype is null or cof.devouttype = '1') "
		    +"and (cof.bsflag is null or cof.bsflag = '0') and cmf.out_org_id ='<%=orgId%>' ) where 1=1 ";
	}else{
		strbase = "select tt1.*,tt2.apply_num, case  when tt3.assign_num=0 then '未分配' when tt2.apply_num-tt3.assign_num=0 then '已分配' when  tt2.apply_num-tt3.assign_num>0 then '分配中'else ''  end as mix_state_desc "
				+"from (SELECT allapp.ALLAPP_TYPE,app.device_app_name,app.STATE,app.appdate,app.device_app_id,app.DEVICE_APP_NO,app.CREATE_DATE,pro.PROJECT_NAME,org.ORG_ABBREVIATION AS app_org_name "
				+"FROM gms_device_app app "
				+"LEFT JOIN GP_TASK_PROJECT pro "
				+"ON app.PROJECT_INFO_NO=pro.PROJECT_INFO_NO AND pro.BSFLAG='0' "
				+"LEFT JOIN COMM_ORG_INFORMATION org "
				+"ON app.ORG_ID=org.ORG_ID AND org.BSFLAG='0' "
				+"LEFT JOIN GMS_DEVICE_ALLAPP allapp "
				+"ON allapp.DEVICE_ALLAPP_ID=app.DEVICE_ALLAPP_ID "
				+"WHERE app.BSFLAG='0' AND (allapp.ALLAPP_TYPE='S0000'  OR allapp.ALLAPP_TYPE='S14050208') "
				+"AND app.DEVICE_APP_ID IN(	SELECT DISTINCT detail.DEVICE_APP_ID FROM gms_device_app_detail detail WHERE detail.BSFLAG='0' )"
				+" union "
				+"select allapp.ALLAPP_TYPE,collapp.device_app_name,collapp.STATE,collapp.APPDATE,collapp.DEVICE_APP_ID,collapp.DEVICE_APP_NO,collapp.CREATE_DATE,pro.PROJECT_NAME,org.ORG_ABBREVIATION AS app_org_name  from gms_device_collapp collapp "
				+" left join GP_TASK_PROJECT pro on pro.PROJECT_INFO_NO=collapp.PROJECT_INFO_NO "
				+" left join GMS_DEVICE_ALLAPP allapp on allapp.DEVICE_ALLAPP_ID=collapp.DEVICE_ALLAPP_ID "
				+" LEFT JOIN COMM_ORG_INFORMATION org ON collapp.ORG_ID=org.ORG_ID AND org.BSFLAG='0'  "
				+"where allapp.ALLAPP_TYPE='S9997'"
				+") tt1 left join (                                                                                                                                                                                          "
					+"select appdet.DEVICE_APP_ID, sum(appdet.APPLY_NUM) as apply_num from GMS_DEVICE_APP_DETAIL appdet where appdet.BSFLAG='0'  group by appdet.DEVICE_APP_ID                                                   "
					+") tt2 on tt1.DEVICE_APP_ID=tt2.DEVICE_APP_ID left join (                                                                                                                                                   "
					+"select sum(t2.assign_num) as assign_num,t1.DEVICE_APP_ID from GMS_DEVICE_APP_DETAIL  t1 left join (                                                                                                        "
					+"select DEVICE_APP_DETID,sum(ASSIGN_NUM) as assign_num from  GMS_DEVICE_APPMIX_MAIN where BSFLAG='0'  group by DEVICE_APP_DETID                                                                             "
					+")t2 on t1.DEVICE_APP_DETID=t2.DEVICE_APP_DETID where t1.BSFLAG='0' group by t1.DEVICE_APP_ID    "
					+") tt3 on tt2.DEVICE_APP_ID=tt3.DEVICE_APP_ID  where 1=1 ";
		}

		if(v_project_name!=undefined && v_project_name!=''){
			strbase+="and PROJECT_NAME like '%"+v_project_name+"%' ";
		}
		if(v_appinfo_no!=undefined && v_appinfo_no!=''){
			strbase+="and DEVICE_APP_NO like '%"+v_appinfo_no+"%' ";
		}
		if(v_appinfo_name!=undefined && v_appinfo_name!=''){
			strbase+="and DEVICE_APP_NAME like '%"+v_appinfo_name+"%' ";	
		}				
		if(v_opr_state_desc!=undefined && v_opr_state_desc!=''){
			strbase+="and mix_state_desc like '%"+v_opr_state_desc+"%' ";
		}
		
		strbase+="order by case mix_state_desc when '未分配' then 1 when '分配中' then 2 when '已分配' then 3 end , appdate desc ";		 
				
	cruConfig.queryStr = strbase;
	queryData(cruConfig.currentPage);

}

	function frameSize(){
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
		//alert(index);
		if(index == 1){			
			//动态查询明细
			var currentid;
			$("input[type='checkbox'][name='selectedbox']").each(function(){
				if(this.checked){
					currentid = this.value;
				}			
			});
			//var idinfo = $(filterobj).attr("idinfo");
			if(currentid != undefined && idinfo == currentid){
				//已经有值，且完成钻取，那么不再钻取
			}else{
				if(currentid==undefined){
					var filtermapid = "#detailList";
					$(filtermapid).empty();
					$(filterobj).attr("idinfo","");
				}else{
					var info = currentid.split("~" , -1);
					debugger;
					if(info[1]!=''){
						//管理员查询该申请单的全部
						if(info[2] == 'S9997'){
							var prosql = "select '1' as type,'调配明细' as showtype,cds.device_name,cds.device_model,"+
								"nvl(temp.outednum, 0) as outednum from gms_device_coll_mixsub cds "+
								"left join (select device_mif_subid, sum(out_num) as outednum "+
								"from gms_device_coll_outsub group by device_mif_subid) temp on temp.device_mif_subid = cds.device_mif_subid where cds.device_mixinfo_id = '"+info[0]+"' and outednum > 0 "+
								"union all "+
								"select '2' as type,'补充明细' as showtype,mix.device_name,mix.device_model,nvl(temp.outednum, 0) as outednum "+
								"from gms_device_coll_mixsubadd mix left join (select device_mif_subid, sum(out_num) as outednum from gms_device_coll_outsubadd group by device_mif_subid) temp "+
								"on temp.device_mif_subid = mix.device_mif_subid where mix.device_mixinfo_id = '"+info[0]+"' and outednum > 0 ";
						}else if(info[2] == 'S14050208'){
							var prosql = "select '1' as type,'调配明细' as showtype,ci.dev_name as device_name,ci.dev_model as device_model,amd.assign_num as outednum "+
								"from gms_device_appmix_main amd "+
								"left join gms_device_appmix_detail amm on amm.device_mix_subid = amd.device_mix_subid "+
								"left join gms_device_collectinfo ci on amd.dev_ci_code = ci.device_id "+
								"where amd.device_mixinfo_id in (select form.device_mixinfo_id from gms_device_mixinfo_form form where form.device_app_id='"+info[1]+"' and form.bsflag='0' and form.out_org_id='<%=orgId%>')  order by  ci.dev_name";						
						}else{
							var prosql = "select '1' as type,'调配明细' as showtype,account.self_num,account.license_num,ci.dev_ci_name as device_name,ci.dev_ci_model as device_model,'1' as outednum ";
								prosql += "from gms_device_appmix_detail amd ";
								prosql += "left join gms_device_appmix_main amm on amm.device_mix_subid=amd.device_mix_subid ";
								prosql += "left join gms_device_codeinfo ci on amd.dev_ci_code=ci.dev_ci_code ";
								prosql += "left join gms_device_account account on account.dev_acc_id=amd.dev_acc_id  ";
								prosql += "left join comm_org_information org on account.owning_org_id=org.org_id "
								
								//prosql += "where amm.device_mixinfo_id='"+info[0]+"'";
								if('<%=orgType%>'=='Y'){
									//如果是服务中心的执行下面这条
									prosql +="where amm.device_mixinfo_id in (select form.device_mixinfo_id from GMS_DEVICE_MIXINFO_FORM form where form.DEVICE_APP_ID='"+info[1]+"' and form.BSFLAG='0' and form.OUT_ORG_ID='<%=orgId%>')  order by  ci.dev_ci_name";								
								}else{
									prosql +="where amm.device_mixinfo_id in (select form.device_mixinfo_id from GMS_DEVICE_MIXINFO_FORM form where form.DEVICE_APP_ID='"+info[1]+"' and form.BSFLAG='0')  order by  ci.dev_ci_name";
								}
						}						
							
						var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+prosql+'&pageSize=1000');
						basedatas = queryRet.datas;
						if(basedatas!=undefined && basedatas.length>=1){
							//先清空
							var filtermapid = "#detailList";
							$(filtermapid).empty();
							appendDataToDetailTab(filtermapid,basedatas);
							//设置当前标签页显示的主键
							$(filterobj).attr("idinfo",currentid);
						}else{
							var filtermapid = "#detailList";
							$(filtermapid).empty();
							$(filterobj).attr("idinfo",currentid);
						}
					}else{
						var filtermapid = "#detailList";
						$(filtermapid).empty();
						$(filterobj).attr("idinfo",currentid);
					}
				}
			}
		}else if(index == 2){
				//动态查询明细
				var currentid;
				$("input[type='checkbox'][name='selectedbox']").each(function(){
					if(this.checked){
						currentid = this.value;
					}			
				});
				var idinfo = $(filterobj).attr("idinfo");
				if(currentid != undefined && idinfo == currentid){
					//已经有值，且完成钻取，那么不再钻取
				}else{
					if(currentid==undefined){
						var filtermapid = "#tpList";
						$(filtermapid).empty();
						$(filterobj).attr("idinfo","");
					}else{
						var info = currentid.split("~" , -1);
							//先进行查询
							var devAppId = "";
								devAppId = info[1];
							var prosql = "select info.org_abbreviation,case when al.mix_total=0 then '未处理' when al.app_total > al.mix_total then '处理中' when al.app_total = al.mix_total then '已处理' end as state from (select appdet.dev_out_org_id,nvl(sum(appdet.apply_num),0) as app_total,nvl(sum(tmp.mixed_num),0) as mix_total  from gms_device_app_detail appdet  left join (select device_app_detid, sum(assign_num) as mixed_num from gms_device_appmix_main amm  where amm.bsflag = '0' group by device_app_detid) tmp on tmp.device_app_detid = appdet.device_app_detid where appdet.device_app_id='"+devAppId+"' group by appdet.dev_out_org_id) al left join comm_org_information info on al.dev_out_org_id = info.org_id";
							var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+prosql+'&pageSize=1000');
							basedatas = queryRet.datas;
							if(basedatas!=undefined && basedatas.length>=1){
								//先清空
								var filtermapid = "#tpList";
								$(filtermapid).empty();
								appendDataToDetailTab(filtermapid,basedatas);
								//设置当前标签页显示的主键
								$(filterobj).attr("idinfo",currentid);
							}else{
								var filtermapid = "#tpList";
								$(filtermapid).empty();
								$(filterobj).attr("idinfo",currentid);
							}
					}
				}
			}else if(index == 3){
				//动态查询明细
				var currentid;
				$("input[type='checkbox'][name='selectedbox']").each(function(){
					if(this.checked){
						currentid = this.value;
					}			
				});
				var idinfo = $(filterobj).attr("idinfo");
				if(currentid != undefined && idinfo == currentid){
					//已经有值，且完成钻取，那么不再钻取
				}else{
					if(currentid==undefined){
						var filtermapid = "#logList";
						$(filtermapid).empty();
						$(filterobj).attr("idinfo","");
					}else{
						var info = currentid.split("~" , -1);
						//alert(info);
							//先进行查询
							var mixinfoid = info[0];
							var	devAppId = info[1];
							var mixtype = info[2];
							if(mixtype == 'S9997'){
								var prosql = "select form.device_mixinfo_id,form.outinfo_no as mixinfo_no,outorg.ORG_ABBREVIATION,form.CREATE_DATE from gms_device_coll_outform form "
									+"left join COMM_ORG_INFORMATION outorg on outorg.ORG_ID=form.OUT_ORG_ID where device_mixinfo_id='"+mixinfoid+"'";
							}else{
								var prosql = "select form.DEVICE_MIXINFO_ID,form.MIXINFO_NO,outorg.ORG_ABBREVIATION,form.CREATE_DATE from GMS_DEVICE_MIXINFO_FORM form "
									+"left join COMM_ORG_INFORMATION outorg on outorg.ORG_ID=form.OUT_ORG_ID where DEVICE_APP_ID='"+devAppId+"'";
							}
							
							if('<%=orgType%>'=='Y'){
								prosql+= " and form.OUT_ORG_ID='<%=orgId%>' ";
							}
							var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+prosql+'&pageSize=1000');
							basedatas = queryRet.datas;
							if(basedatas!=undefined && basedatas.length>=1){
								//先清空
								var filtermapid = "#logList";
								$(filtermapid).empty();
								appendLogToDetailTab(filtermapid,basedatas);
								//设置当前标签页显示的主键
								$(filterobj).attr("idinfo",currentid);
							}else{
								var filtermapid = "#logList";
								$(filtermapid).empty();
								$(filterobj).attr("idinfo",currentid);
							}
					}
				}
			}

		$(filternotobj).hide();
		$(filterobj).show();
	}
	function loadDataDetail(shuaId){
	    	var retObj;
	    	var ids;
			if(shuaId!=null){
				ids = shuaId;
			}else{
				ids = getSelIds('selectedbox');
			    if(ids==''){ 
				    alert("请先选中一条记录!");
		     		return;
			    }
			}
			var info = ids.split("~",-1);
				//根据ids去查找 申请单
			var str = "select devapp.device_app_name,devapp.device_app_id,devapp.device_app_no,to_char(devapp.appdate,'yyyy-mm-dd') as appdate,apporg.org_abbreviation as app_org_name,";
				str += "tp.project_name,mixorg.org_abbreviation as mix_org_name ";
			if(info[2] == 'S9997'){
				str += "from gms_device_collapp devapp ";
			}else{
				str += "from gms_device_app devapp ";					
			}
				str += "left join gp_task_project tp on devapp.project_info_no=tp.project_info_no "
				+"left join comm_org_information apporg on devapp.app_org_id=apporg.org_id "
				+"left join comm_org_information mixorg on devapp.mix_org_id=mixorg.org_id "
				+"where devapp.device_app_id='"+info[1]+"'";
				
				var unitRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+str);
				retObj = unitRet.datas;
				if(info[0]!='' && info[0] != 'undefined'){
					//取消其他选中的
					$("input[type='checkbox'][name='selectedbox'][id!='selectedbox_"+info[0]+"~"+info[1]+"']").removeAttr("checked");
					//选中这一条checkbox
					$("input[type='checkbox'][name='selectedbox'][id='selectedbox_"+info[0]+"~"+info[1]+"']").attr("checked",'true');
				}else{
					//取消其他选中的
					$("input[type='checkbox'][name='selectedbox'][id!='selectedbox_~"+retObj[0].device_app_id+"']").removeAttr("checked");
					//选中这一条checkbox
					$("input[type='checkbox'][name='selectedbox'][id='selectedbox_~"+retObj[0].device_app_id+"']").attr("checked",'true');
					//选中这一条checkbox
				}
				$("#project_name").val(retObj[0].project_name);
				$("#device_app_no").val(retObj[0].device_app_no);
				$("#app_org_name").val(retObj[0].app_org_name);
				$("#device_app_name").val(retObj[0].device_app_name);
				$("#appdate").val(retObj[0].appdate);
			//}
		
	    	getContentTab(undefined,selectedTagIndex);
	  }

	function dbclickRow(shuaId){

		var info = shuaId.split("~" , -1);
		//alert(info);
		if(info[2]=='S9997'){//地震仪器
			popWindow('<%=contextPath%>/rm/dm/collDevOutForm/collDevOutInfoNew_dg.jsp?mixInfoId='+info[0],'950:680');
		}else if(info[2]=='S14050208'){//检波器
			popWindow('<%=contextPath%>/rm/dm/devmixForm/devMixInfoJBQNew_dg.jsp?devappid='+info[1],'1050:680');
		}else{
			popWindow('<%=contextPath%>/rm/dm/devPlanMulti/ownEqDevInfoFromNew_dg.jsp?devappid='+info[1],'1050:680');
		}
	}
	function toAddDetailPage(){
		var shuaId ;
		$("input[type='checkbox'][name='selectedbox']").each(function(){
			if(this.checked){
				shuaId = this.value;
			}
		});
		if(shuaId == undefined){
			alert("请选择一条记录!");
			return;
		}
		var info = shuaId.split("~" , -1);
		if(info[2]=='S9997'){//地震仪器
			popWindow('<%=contextPath%>/rm/dm/collDevOutForm/collDevOutInfoNew_dg.jsp?mixInfoId='+info[0],'950:680');
		}else if(info[2]=='S14050208'){//检波器
			popWindow('<%=contextPath%>/rm/dm/devmixForm/devMixInfoJBQNew_dg.jsp?devappid='+info[1],'1050:680');
		}else{
			popWindow('<%=contextPath%>/rm/dm/devPlanMulti/ownEqDevInfoFromNew_dg.jsp?devappid='+info[1],'1050:680');
		}
	}
	
	function appendDataToDetailTab(filterobj,datas){
			for(var i=0;i<basedatas.length;i++){
				var innerHTML = "<tr>";
				innerHTML += "<td>"+(i+1)+"</td><td>"+datas[i].showtype+"</td><td>"+datas[i].device_name+"</td>";
				if(dgys == 'Y'){
					innerHTML += "<td>"+datas[i].license_num+"</td><td>"+datas[i].self_num+"</td>";
				}
				innerHTML += "<td>"+datas[i].device_model+"</td><td>"+datas[i].outednum+"</td>";
				innerHTML += "</tr>";
				
				$(filterobj).append(innerHTML);
			}
		
		$(filterobj+">tr:odd>td:odd").addClass("odd_odd");
		$(filterobj+">tr:odd>td:even").addClass("odd_even");
		$(filterobj+">tr:even>td:odd").addClass("even_odd");
		$(filterobj+">tr:even>td:even").addClass("even_even");
	}

	function appendLogToDetailTab(filterobj,datas){
		for(var i=0;i<basedatas.length;i++){
			var innerHTML = "<tr>";
			innerHTML += "<td>"+(i+1)+"</td><td>"+datas[i].mixinfo_no+"</td><td>"+datas[i].org_abbreviation+"</td><td>"+datas[i].create_date+"</td>";
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
</html>
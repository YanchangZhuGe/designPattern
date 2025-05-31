<%@ page contentType="text/html;charset=utf-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.bgp.gms.service.rm.dm.constants.DevConstants"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String orgsubid = user.getSubOrgIDofAffordOrg();
	String devbackappid = request.getParameter("devBackAppId");
	String devbacktype = request.getParameter("devBackType");
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
  <title>多项目-调配调剂-调配单管理(项目返还)-更换设备子页面</title>
 </head> 
 
 <body style="background:#cdddef" onload="refreshData()">
      	<div id="list_table">
			<div id="table_box">
			  <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">		
			     <tr id='device_mixinfo_id_{device_mixinfo_id}' name='device_mixinfo_id'>
			     	<td class="bt_info_even" exp="<input type='checkbox' name='selectedbox' mixstate='{state}' value='{device_mixinfo_id}~{device_backapp_id}' id='selectedbox_{device_mixinfo_id}~{device_backapp_id}' />" >选择</td>
					<td class="bt_info_odd" autoOrder="1">序号</td>
					<td class="bt_info_even" exp="{mix_org_name}">调配单位</td>
					<td class="bt_info_odd" exp="{mix_state_desc}">调配状态</td>
					<td class="bt_info_even" exp="{backmixinfo_no}">调配单号</td>
					<td class="bt_info_odd" exp="{out_org_name}">接收单位</td>
					<td class="bt_info_even" exp="{employee_name}">调配人</td>
					<td class="bt_info_odd" exp="{mix_date}">调配时间</td>
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
			    <li id="tag3_2"><a href="#" onclick="getContentTab(this,2)">审批信息</a></li>
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
				<td class="inquire_form6"><input id="project_name" name="" class="input_width" type="text" /></td>
				<td class="inquire_item6">调配申请单号</td>
				<td class="inquire_form6"><input id="device_app_no" name="" class="input_width" type="text" /></td>
				<td class="inquire_item6">申请时间</td>
				<td class="inquire_form6"><input id="appdate" name="" class="input_width" type="text" /></td>
			  </tr>
			  <tr>
				<td class="inquire_item6">调配单位</td>
				<td class="inquire_form6"><input id="mix_org_name" name="" class="input_width" type="text" /></td>
				<td class="inquire_item6">调配状态</td>
				<td class="inquire_form6"><input id="mix_state_desc" name="" class="input_width" type="text" /></td>
				<td class="inquire_item6">接收单位</td>
				<td class="inquire_form6"><input id="out_org_name" name="" class="input_width" type="text" /><input id="out_org_id" name="" class="input_width" type="hidden" /></td>
			  </tr>
			  <tr>
				<td class="inquire_item6">调配单号</td>
				<td class="inquire_form6"><input id="mixinfo_no" name="" class="input_width" type="text" /></td>
				<td class="inquire_item6">调配人</td>
				<td class="inquire_form6"><input id="employee_name" name="" class="input_width" type="text" /></td>
				<td class="inquire_item6">调配时间</td>
				<td class="inquire_form6"><input id="mix_date" name="" class="input_width" type="text" /></td>
			  </tr>
			</table>
				</div>
				<div id="tab_box_content1" name="tab_box_content1" idinfo="" class="tab_box_content" style="display:none">
					<table border="0" cellpadding="0" cellspacing="0"  class="tab_line_height" width="100%" style="margin-top:10px;background:#efefef"> 
						<tr class="bt_info">
				    		<td class="bt_info_odd" width="5%">序号</td>
							<td class="bt_info_even" width="11%">设备名称</td>
							<td class="bt_info_odd" width="11%">规格型号</td>
							<td class="bt_info_even" width="10%">设备编号</td>
							<td class="bt_info_odd" width="13%">自编号</td>
							<td class="bt_info_even" width="10%">实物标识号</td>
							<td class="bt_info_odd" width="13%">牌照号</td>
				        </tr>
				        <tbody id="detailList" name="detailList" ></tbody>
					</table>
				</div>
				<div id="tab_box_content2" name="tab_box_content2" class="tab_box_content" style="display:none"></div>
				<div id="tab_box_content3" name="tab_box_content3" class="tab_box_content" style="display:none"></div>
				<div id="tab_box_content4" name="tab_box_content4" class="tab_box_content" style="display:none"></div>
			    <div id="tab_box_content5" name="tab_box_content5" class="tab_box_content" style="display:none"></div>
				<div id="tab_box_content6" name="tab_box_content6" class="tab_box_content" style="display:none"></div>
		 </div>
</div>
</body>
<script type="text/javascript">
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
		if(index == 1){
			var own_org_id = $("#out_org_id").val();
			//动态查询明细
			var currentid ;
			$("input[type='checkbox'][name='selectedbox']").each(function(){
				if(this.checked){
					currentid = this.value
				}
			});
			var idinfo = $(filterobj).attr("idinfo");
			if(currentid != undefined && idinfo == currentid){
				//已经有值，且完成钻取，那么不再钻取				
			}else{				
				if(currentid==undefined){
					var filtermapid = "#detailList";
					$(filtermapid).empty();
					$(filterobj).attr("idinfo","");
				}else{
					var info = currentid.split("~" , -1);
					if(info[0]!=''){
						var prosql = "select ci.dev_ci_name,ci.dev_ci_model,";
							prosql +="detail.dev_coding,detail.self_num,detail.dev_sign,detail.license_num ";
							prosql +="from gms_device_backapp_detail detail ";
							prosql +="join gms_device_account_dui dui on detail.dev_acc_id = dui.dev_acc_id ";
							prosql +="join gms_device_codeinfo ci on dui.dev_type = ci.dev_ci_code ";
							prosql +="where detail.device_mixinfo_id = '"+info[0]+"' ";
							prosql +="union all ";
							prosql +="select account.dev_name,account.dev_model,account.dev_coding,amd.self_num,amd.dev_sign,amd.license_num ";
							prosql +="from gms_device_appmix_detail amd ";
							prosql +="left join gms_device_account account on amd.dev_acc_id = account.dev_acc_id ";
							prosql +="left join gms_device_appmix_main amm on amd.device_mix_subid = amm.device_mix_subid ";
							prosql +="left join gms_device_mixinfo_form mif on amm.device_mixinfo_id = mif.device_mixinfo_id ";
							prosql +="left join gp_task_project pro on pro.project_info_no = mif.project_info_no ";
							prosql +=" where mif.device_mixinfo_id = '"+info[0]+"' ";
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
		}
		$(filternotobj).hide();
		$(filterobj).show();
	}
	
	function appendDataToDetailTab(filterobj,datas){
		for(var i=0;i<basedatas.length;i++){
			var innerHTML = "<tr>";
			innerHTML += "<td>"+(i+1)+"</td><td>"+datas[i].dev_ci_name+"</td><td>"+datas[i].dev_ci_model+"</td>";
			innerHTML += "<td>"+datas[i].dev_coding+"</td><td>"+datas[i].self_num+"</td>";
			innerHTML += "<td>"+datas[i].dev_sign+"</td><td>"+datas[i].license_num+"</td>";
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

	var devbacktypes = '<%=devbacktype%>';
		
	function refreshData(){
		var str = "select devapp.device_backapp_id,devapp.device_backapp_no,to_char(devapp.backdate,'yyyy-mm-dd') as appdate,apporg.org_abbreviation as app_org_name,"
				+"mif.device_mixinfo_id,mif.backmixinfo_no,tp.project_name,mixorg.org_abbreviation as mix_org_name,devapp.backapp_name,"
				+"outorg.org_abbreviation as out_org_name,he.employee_name,to_char(mif.modifi_date,'yyyy-mm-dd') as mix_date,"
				+"case mif.state when '0' then '调配中' when '9' then '已调配' else '待调配' end as mix_state_desc,mif.state "
				+"from gms_device_backapp devapp "
				+"left join gp_task_project tp on devapp.project_info_id=tp.project_info_no " 
				+"left join gms_device_backinfo_form mif on mif.device_backapp_id=devapp.device_backapp_id " 
				+"left join comm_human_employee he on mif.print_emp_id=he.employee_id "
				+"left join comm_org_information apporg on devapp.back_org_id=apporg.org_id "
				+"left join comm_org_information mixorg on devapp.backmix_org_id=mixorg.org_id "
				+"left join comm_org_information outorg on mif.own_org_id=outorg.org_id "
				+"left join comm_org_subjection orgsub on devapp.backmix_org_id=orgsub.org_id and orgsub.bsflag='0' "
				+"where devapp.state='9'  and devapp.bsflag='0' and devapp.device_backapp_id = '<%=devbackappid%>' and (mif.bsflag is null or mif.bsflag='0') "
				+"and devapp.backdevtype = '<%=DevConstants.MIXTYPE_COMMON%>' and orgsub.org_subjection_id like '<%=orgsubid%>%' "
				+"union all "
				+"select devapp.device_backapp_id,devapp.device_backapp_no,to_char(devapp.backdate,'yyyy-mm-dd') as appdate,apporg.org_abbreviation as app_org_name,"
				+"mif.device_mixinfo_id,mif.mixinfo_no,tp.project_name,outorg.org_abbreviation as mix_org_name,devapp.backapp_name,"
				+"mixorg.org_abbreviation as out_org_name,he.employee_name,to_char(mif.modifi_date,'yyyy-mm-dd') as mix_date,"
				+"case mif.state when '0' then '调配中' when '9' then '已调配' else '待调配' end as mix_state_desc,mif.state "
				+"from gms_device_backapp devapp "
				+"left join gp_task_project tp on devapp.project_info_id=tp.project_info_no " 
				+"left join gms_device_mixinfo_form mif on mif.device_app_id = devapp.device_backapp_id " 
				+"left join comm_human_employee he on mif.print_emp_id=he.employee_id "
				+"left join comm_org_information apporg on devapp.back_org_id=apporg.org_id "
				+"left join comm_org_information mixorg on devapp.backmix_org_id=mixorg.org_id "
				+"left join comm_org_information outorg on mif.out_org_id=outorg.org_id "
				+"left join comm_org_subjection orgsub on devapp.backmix_org_id=orgsub.org_id and orgsub.bsflag='0' "
				+"where devapp.state='9'  and devapp.bsflag='0' and devapp.device_backapp_id = '<%=devbackappid%>' and (mif.bsflag is null or mif.bsflag='0') "
				+"and mif.mixform_type='5' and devapp.backdevtype = '<%=DevConstants.MIXTYPE_COMMON%>' and orgsub.org_subjection_id like '<%=orgsubid%>%' ";
		cruConfig.queryStr = str;
		queryData(cruConfig.currentPage);;
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
		if(info[0]!=''){
			//根据ids去查找
			var str = "select devapp.device_backapp_id,devapp.device_backapp_no,to_char(devapp.backdate,'yyyy-mm-dd') as appdate,apporg.org_abbreviation as app_org_name,"
			+"mif.device_mixinfo_id,mif.backmixinfo_no,tp.project_name,mixorg.org_abbreviation as mix_org_name,"
			+"mif.own_org_id,outorg.org_abbreviation as out_org_name,he.employee_name,to_char(mif.modifi_date,'yyyy-mm-dd') as mix_date,"
			+"case mif.state when '0' then '调配中' when '9' then '已调配' else '待调配' end as mix_state_desc,mif.state "
			+"from gms_device_backapp devapp "
			+"left join gp_task_project tp on devapp.project_info_id=tp.project_info_no " 
			+"left join gms_device_backinfo_form mif on mif.device_backapp_id=devapp.device_backapp_id " 
			+"left join comm_human_employee he on mif.print_emp_id=he.employee_id "
			+"left join comm_org_information apporg on devapp.back_org_id=apporg.org_id "
			+"left join comm_org_information mixorg on devapp.backmix_org_id=mixorg.org_id "
			+"left join comm_org_information outorg on mif.own_org_id=outorg.org_id "
			+"where devapp.state='9' and mif.device_mixinfo_id='"+info[0]+"' "
			+"union all "
			+"select devapp.device_backapp_id,devapp.device_backapp_no,to_char(devapp.backdate,'yyyy-mm-dd') as appdate,apporg.org_abbreviation as app_org_name,"
			+"mif.device_mixinfo_id,mif.mixinfo_no,tp.project_name,outorg.org_abbreviation as mix_org_name,"
			+"mif.out_org_id,mixorg.org_abbreviation as out_org_name,he.employee_name,to_char(mif.modifi_date,'yyyy-mm-dd') as mix_date,"
			+"case mif.state when '0' then '调配中' when '9' then '已调配' else '待调配' end as mix_state_desc,mif.state "
			+"from gms_device_backapp devapp "
			+"left join gp_task_project tp on devapp.project_info_id=tp.project_info_no " 
			+"left join gms_device_mixinfo_form mif on mif.device_app_id = devapp.device_backapp_id " 
			+"left join comm_human_employee he on mif.print_emp_id=he.employee_id "
			+"left join comm_org_information apporg on devapp.back_org_id=apporg.org_id "
			+"left join comm_org_information mixorg on devapp.backmix_org_id=mixorg.org_id "
			+"left join comm_org_information outorg on mif.out_org_id=outorg.org_id "
			+"where devapp.state='9' and mif.device_mixinfo_id='"+info[0]+"' ";
			var unitRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+str);
			retObj = unitRet.datas;
			//取消选中框--------------------------------------------------------------------------
			//取消其他选中的
			$("input[type='checkbox'][name='selectedbox'][id!='selectedbox_"+retObj[0].device_mixinfo_id+"~"+retObj[0].device_backapp_id+"']").removeAttr("checked");
			//选中这一条checkbox
			$("input[type='checkbox'][name='selectedbox'][id='selectedbox_"+retObj[0].device_mixinfo_id+"~"+retObj[0].device_backapp_id+"']").attr("checked",'true');
			//------------------------------------------------------------------------------------
			$("#project_name").val(retObj[0].project_name);
			$("#device_app_no").val(retObj[0].device_backapp_no);
			$("#app_org_name").val(retObj[0].app_org_name);
			$("#appdate").val(retObj[0].appdate);
			$("#mix_org_name").val(retObj[0].mix_org_name);
			$("#mix_state_desc").val(retObj[0].mix_state_desc);
			$("#mixinfo_no").val(retObj[0].backmixinfo_no);
			
			$("#out_org_name").val(retObj[0].out_org_name);
			$("#employee_name").val(retObj[0].employee_name);
			$("#mix_date").val(retObj[0].mix_date);
			
			$("#out_org_id").val(retObj[0].own_org_id);
		}else{
			//根据ids去查找 申请单
			var str = "select devapp.device_backapp_id,devapp.device_backapp_no,to_char(devapp.backdate,'yyyy-mm-dd') as appdate,apporg.org_abbreviation as app_org_name,"
			+"tp.project_name,mixorg.org_abbreviation as mix_org_name,'待调配' as mix_state_desc "
			+"from gms_device_backapp devapp "
			+"left join common_busi_wf_middle wfmiddle on devapp.device_backapp_id=wfmiddle.business_id "
			+"left join gp_task_project tp on devapp.project_info_id=tp.project_info_no " 
			+"left join comm_org_information apporg on devapp.back_org_id=apporg.org_id "
			+"left join comm_org_information mixorg on devapp.backmix_org_id=mixorg.org_id "
			+"where devapp.state='9' and devapp.device_backapp_id='"+info[1]+"'";
			var unitRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+str);
			retObj = unitRet.datas;
			//取消其他选中的
			$("input[type='checkbox'][name='selectedbox'][id!='selectedbox_~"+retObj[0].device_backapp_id+"']").removeAttr("checked");
			//选中这一条checkbox
			$("input[type='checkbox'][name='selectedbox'][id='selectedbox_~"+retObj[0].device_backapp_id+"']").attr("checked",'true');
			//选中这一条checkbox
			//------------------------------------------------------------------------------------
			$("#project_name").val(retObj[0].project_name);
			$("#device_app_no").val(retObj[0].device_backapp_no);
			$("#app_org_name").val(retObj[0].app_org_name);
			$("#appdate").val(retObj[0].appdate);
			$("#mix_org_name").val(retObj[0].mix_org_name);
			$("#mix_state_desc").val(retObj[0].mix_state_desc);
			$("#mixinfo_no").val(retObj[0].backmixinfo_no);
			
			$("#out_org_name").val("");
			$("#employee_name").val("");
			$("#mix_date").val("");
		}
		//重新加载当前标签页信息
		getContentTab(undefined,selectedTagIndex);
    }
</script>
</html>
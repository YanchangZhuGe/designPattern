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
  <title>单项目-设备接收-大港设备接收(专业化)</title> 
 </head> 
 
 <body style="background:#fff" onload="refreshData()">
      	<div id="list_table">
			<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td class="ali_cdn_name">申请单名称</td>
			    <td class="ali_cdn_input"><input id="s_device_app_name" name="s_device_app_name" type="text" /></td>
			    <td class="ali_cdn_name">出库单号</td>
			    <td class="ali_cdn_input"><input id="s_mixinfo_no" name="s_mixinfo_no" type="text" /></td>
			    <td class="ali_cdn_name">设备类型</td>
			   <td class="ali_cdn_input">
			    	<select id="s_allapp_type" name="s_allapp_type" class="select_width" >
			    	    <option value="" selected="selected">--请选择--</option>
						<option value="0">专业化震源</option>
						<option value="1">专业化测量</option>
						<option value="2">专业化仪器</option>
						<option value="3">仪器附属设备</option>
			    	</select>
			    </td>
			    <td class="ali_cdn_name">处理状态</td>
			    <td class="ali_cdn_input">
			    	<select id="s_opr_state" name="s_opr_state" class="select_width" >
			    	    <option value="" selected="selected">--请选择--</option>
						<option value="0">未处理</option>
						<option value="1">处理中</option>
						<option value="9">已处理</option>
			    	</select>
			    </td>
			    <td class="ali_query">
				    <span class="cx"><a href="#" onclick="searchDevData()" title="查询"></a></span>
			    </td>
			    <td class="ali_query">
				    <span class="qc"><a href="#" onclick="clearQueryText()" title="清除"></a></span>
			    </td>
			    <td>&nbsp;</td>
			    <auth:ListButton functionId="" css="jh" event="onclick='toDetailPage()'" title="JCDP_btn_submit"></auth:ListButton>
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
			     <tr id='device_outinfo_id_{device_outinfo_id}' name='device_outinfo_id'>
			     	<td class="bt_info_even" exp="<input type='checkbox' name='selectedbox' value='{device_outinfo_id}~{mix_type_id}' id='selectedbox_{device_outinfo_id}~{mix_type_id}'  onclick='chooseOne(this)'/>" >选择</td>
					<td class="bt_info_odd" autoOrder="1">序号</td>
					<td class="bt_info_even" exp="{device_app_name}">申请单名称</td>
					<td class="bt_info_odd" exp="{outinfo_no}">出库单号</td>
					<td class="bt_info_even" exp="{in_org_name}">转入单位</td>
					<td class="bt_info_even" exp="{out_org_name}">转出单位</td>
					<td class="bt_info_odd" exp="{employee_name}">开据人</td>
					<td class="bt_info_even" exp="{out_date}">出库时间</td>
					<td class="bt_info_even" exp="{mix_type_name}">设备类型</td>
					<td class="bt_info_odd" exp="{oprstate_desc}">处理状态</td>
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
				<td class="inquire_item6">转入单位</td>
				<td class="inquire_form6"><input id="dev_in_org" name="" class="input_width" type="text" /></td>
			  </tr>
				<tr>
				<td class="inquire_item6">转出单位</td>
				<td class="inquire_form6"><input id="dev_out_org" name="" class="input_width" type="text" /></td>
				<td class="inquire_item6">开据人</td>
				<td class="inquire_form6"><input id="dev_print_emp" name="" class="input_width" type="text" /></td>
				<td class="inquire_item6">出库时间</td>
				<td class="inquire_form6"><input id="dev_create_date" name="" class="input_width" type="text" /></td>
			  </tr>
				<tr>
				<td class="inquire_item6">处理状态</td>
				<td class="inquire_form6"><input id="dev_state" name="" class="input_width" type="text" /></td>
			  </tr>
			</table>
				</div>
				<div id="tab_box_content1" name="tab_box_content1" idinfo="" class="tab_box_content" style="display:none">
					<table id="pro1" border="0" cellpadding="0" cellspacing="0"  class="tab_line_height" width="100%" style="margin-top:10px;background:#efefef"> 
						<tr class="bt_info">
				    		<td class="bt_info_odd" width="5%">序号</td>
				    		<td class="bt_info_even" width="15%">项目名称</td>
<!-- 				        <td class="bt_info_odd" width="15%">设备编号</td> -->
							<td class="bt_info_odd" width="11%">设备名称</td>
							<td class="bt_info_even" width="11%">规格型号</td>
							<td class="bt_info_odd" width="10%">自编号</td>
							<td class="bt_info_even" width="9%">牌照号</td>
							<td class="bt_info_odd" width="11%">实物标识号</td>
							<td class="bt_info_even" width="13%">实际进场时间</td>
							<td class="bt_info_odd" width="13%">计划离场时间</td>
				        </tr>
				        <tbody id="detailMap" name="detailMap" ></tbody>
					</table>
					
				<table id="pro2" border="0" cellpadding="0" cellspacing="0"  class="tab_line_height" width="100%" style="margin-top:10px;background:#efefef"> 
						<tr class="bt_info">
				    		<td class="bt_info_odd" width="5%">序号</td>
							<td class="bt_info_even" width="11%">设备名称</td>
							<td class="bt_info_odd" width="11%">规格型号</td>
							<td class="bt_info_even" width="10%">出库数量</td>
							<td class="bt_info_odd" width="13%">接收状态</td>
				        </tr>
				        <tbody id="detailList" name="detailList" ></tbody>
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
		var mixTypeId="";
		$("input[type='checkbox'][name='selectedbox']").each(function(){
			if(this.checked){
				currentid = this.value;
				mixTypeId = currentid.split("~")[1];
				currentid = currentid.split("~")[0];
			}
		});
		if(index == 1){
			//动态查询明细
			//var idinfo = $(filterobj).attr("idinfo");
			//if(currentid != undefined && idinfo == currentid){
				//已经有值，且完成钻取，那么不再钻取
			//}else{
				//先进行查询
				if(mixTypeId=='S1405'){
					$("#pro2").show();
					$("#pro1").hide();
					var str = "select device_oif_subid,device_name,device_model,out_num,detail.coding_name as unit_name,"+
					"case sub.receive_state when '0' then '未接收' when '1' then '已接收' end as recstate_desc "+
					"from gms_device_coll_outsub sub "+
					"left join comm_coding_sort_detail detail on sub.unit_id = detail.coding_code_id "+
					"where sub.device_outinfo_id='"+currentid+"'";
						var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+str);
						basedatas = queryRet.datas;
						
						if(basedatas!=undefined && basedatas.length>=1){
							//先清空
							var filtermapid = "#detailList";
							$(filtermapid).empty();
							appendDataToDetailTab2(filtermapid,basedatas);
							//设置当前标签页显示的主键
							$(filterobj).attr("idinfo",currentid);
						}else{
							var filtermapid = "#detailList";
							$(filtermapid).empty();
							$(filterobj).attr("idinfo",currentid);
						}
					
				}else if(mixTypeId =='S9995'){
					$("#pro1").show();
					$("#pro2").hide();
					var prosql = "select '' as actual_in_time,amd.dev_acc_id, amd.asset_coding,amd.dev_plan_start_date,amd.dev_plan_end_date,pro.project_name, ";
					prosql += "amd.self_num, amd.dev_sign, amd.license_num, amd.state,acc.dev_name,acc.dev_model ";
					prosql += "from gms_device_equ_outdetail_added amd ";
					prosql += "left join gms_device_account acc on acc.dev_acc_id = amd.dev_acc_id ";
					prosql += "left join gms_device_coll_outform m on amd.device_outinfo_id = m.device_outinfo_id ";
					prosql += "left join gp_task_project pro on pro.project_info_no = m.project_info_no ";
					prosql += "where amd.device_outinfo_id='"+currentid+"'";
					var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+prosql);
					basedatas = queryRet.datas;
					if(basedatas!=undefined && basedatas.length>=1){
						//先清空
						var filtermapid = "#detailMap";
						$(filtermapid).empty();
						appendDataToDetailTab1(filtermapid,basedatas);
						//设置当前标签页显示的主键
						$(filterobj).attr("idinfo",currentid);
					}else{
						var filtermapid = "#detailMap";
						$(filtermapid).empty();
						$(filterobj).attr("idinfo",currentid);
					}
				}else{
					$("#pro1").show();
					$("#pro2").hide();
					var prosql = "select amd.actual_in_time,amd.dev_acc_id, amd.asset_coding,amd.dev_plan_start_date,amd.dev_plan_end_date,pro.project_name, ";
					prosql += "amd.self_num, amd.dev_sign, amd.license_num, amd.state,account.dev_name,account.dev_model ";
					prosql += "from gms_device_equ_outdetail amd ";
					prosql += "left join gms_device_account account on amd.dev_acc_id=account.dev_acc_id ";
					prosql += "left join gms_device_equ_outsub amm on amd.device_oif_subid=amm.device_oif_subid ";
					prosql += "left join gms_device_equ_outform eof on eof.device_outinfo_id=amm.device_outinfo_id ";
					prosql += "left join gp_task_project pro on pro.project_info_no=eof.project_info_no ";
					prosql += "where eof.device_outinfo_id='"+currentid+"'";
					var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+prosql);
					basedatas = queryRet.datas;
					if(basedatas!=undefined && basedatas.length>=1){
						//先清空
						var filtermapid = "#detailMap";
						$(filtermapid).empty();
						appendDataToDetailTab1(filtermapid,basedatas);
						//设置当前标签页显示的主键
						$(filterobj).attr("idinfo",currentid);
					}else{
						var filtermapid = "#detailMap";
						$(filtermapid).empty();
						$(filterobj).attr("idinfo",currentid);
					}
				}
				
			//}
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
	
	function appendDataToDetailTab1(filterobj,datas){
		for(var i=0;i<basedatas.length;i++){
			var innerHTML = "<tr>";
			innerHTML += "<td>"+(i+1)+"</td><td>"+datas[i].project_name+"</td><td>"+datas[i].dev_name+"</td>";
			innerHTML += "<td>"+datas[i].dev_model+"</td><td>"+datas[i].self_num+"</td><td>"+datas[i].license_num+"</td>";
			innerHTML += "<td>"+datas[i].dev_sign+"</td><td>"+datas[i].actual_in_time+"</td><td>"+datas[i].dev_plan_end_date+"</td>";
			innerHTML += "</tr>";
			
			$(filterobj).append(innerHTML);
		}
		$(filterobj+">tr:odd>td:odd").addClass("odd_odd");
		$(filterobj+">tr:odd>td:even").addClass("odd_even");
		$(filterobj+">tr:even>td:odd").addClass("even_odd");
		$(filterobj+">tr:even>td:even").addClass("even_even");
	}

	function appendDataToDetailTab2(filterobj,datas){
		for(var i=0;i<basedatas.length;i++){
			var innerHTML = "<tr>";
			innerHTML += "<td>"+(i+1)+"</td><td>"+datas[i].device_name+"</td><td>"+datas[i].device_model+"</td>";
			innerHTML += "<td>"+datas[i].out_num+"</td><td>"+datas[i].recstate_desc+"</td>";
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
	var projectCommon="<%=projectCommon%>";
	var ret;
	var retFatherNo;
	var sonFlag = null;//是否为子项目标志
	
	function searchDevData(){
		var v_device_app_name = document.getElementById("s_device_app_name").value;
		var v_mixinfo_no = document.getElementById("s_mixinfo_no").value;
		var v_allapp_type = document.getElementById("s_allapp_type").value;		
		var v_opr_state = document.getElementById("s_opr_state").value;
		
		refreshData(v_device_app_name, v_mixinfo_no, v_opr_state, v_allapp_type);
	}
	//清空查询条件
    function clearQueryText(){
    	document.getElementById("s_device_app_name").value="";
		document.getElementById("s_mixinfo_no").value="";
		document.getElementById("s_opr_state").value="";
		document.getElementById("s_allapp_type").value="";
    }
	function refreshData(v_device_app_name,v_mixinfo_no,v_opr_state,v_allapp_type){
		var str = "select * from ( ";		
		 	str += "select mif.mix_type_id,outform.create_date,devapp.device_app_name,outform.device_outinfo_id,outform.outinfo_no,outform.PROJECT_INFO_NO,pro.project_name,";
		    str += "inorg.org_abbreviation as in_org_name,outorg.org_abbreviation as out_org_name,";
		    str += "he.employee_name,outform.receive_state,outform.out_date,";
		    str += "outform.opr_state,case outform.opr_state when '1' then '处理中' when '9' then '已处理' else '未处理' end as oprstate_desc,case mif.mix_type_id when 'S0623' then '专业化震源' when 'S1404' then '专业化测量' end mix_type_name ";
		    str += "from gms_device_equ_outform outform ";
		    str += "left join gms_device_mixinfo_form mif on outform.device_mixinfo_id=mif.device_mixinfo_id ";
		    str += "left join gms_device_app devapp on devapp.device_app_id=mif.device_app_id ";
		    str += "left join gms_device_allapp allapp on devapp.device_allapp_id = allapp.device_allapp_id ";
		    str += "left join comm_org_information inorg on outform.in_org_id=inorg.org_id ";
		    str += "left join comm_org_subjection sub on outform.out_org_id=sub.org_subjection_id left join comm_org_information outorg on sub.org_id=outorg.org_id ";
		    str += "left join comm_human_employee he on outform.print_emp_id=he.employee_id ";
			str += "left join gp_task_project pro on outform.project_info_no = pro.project_info_no and pro.bsflag = '0' ";
	        str += "where outform.state='9' and outform.bsflag='0' and (allapp.allapp_type = 'S0623' or allapp.allapp_type = 'S1404') and outform.project_info_no='"+projectInfoNos+"' ";
	        str += "union all ";		     
			str += "SELECT 'S1405' as mix_type_id,outform.create_date,devapp.device_app_name,outform.device_outinfo_id,outform.outinfo_no,outform.PROJECT_INFO_NO,pro.project_name,inorg.org_abbreviation AS in_org_name,outorg.org_abbreviation AS out_org_name,he.employee_name, ";
	        str+= "outform.receive_state,outform.CREATE_DATE as out_date,outform.opr_state,CASE outform.opr_state WHEN '1' THEN '处理中' WHEN '9' THEN '已处理' ELSE '未处理' END AS oprstate_desc,'专业化仪器' as mix_type_name  ";
	        str += "FROM gms_device_coll_outform outform ";
	    	str += "LEFT JOIN GMS_DEVICE_COLLMIX_FORM mif ON outform.device_mixinfo_id=mif.device_mixinfo_id ";
	    	str += "LEFT JOIN gms_device_collapp devapp ON devapp.device_app_id=mif.device_app_id ";
	    	str += "left join gms_device_allapp allapp on devapp.device_allapp_id = allapp.device_allapp_id ";
	    	str += "LEFT JOIN comm_org_information inorg 	ON outform.in_org_id=inorg.org_id ";
	    	str += "LEFT JOIN comm_org_subjection sub ON outform.out_org_id=sub.org_subjection_id ";
	    	str += "LEFT JOIN comm_org_information outorg ON outform.out_org_id=outorg.org_id ";
	    	str += "LEFT JOIN comm_human_employee he 	ON outform.print_emp_id=he.employee_id ";
	    	str += "LEFT JOIN gp_task_project pro ON outform.project_info_no = pro.project_info_no AND pro.bsflag = '0' ";
	    	str += "WHERE outform.STATE='9' AND outform.bsflag='0' and allapp.allapp_type = 'S1405' AND outform.project_info_no='"+projectInfoNos+"' ";
	    	str += "union all ";		     
			str += "SELECT 'S9995' as mix_type_id,outform.create_date,devapp.device_app_name,outform.device_outinfo_id,outform.outinfo_no,outform.PROJECT_INFO_NO,pro.project_name,inorg.org_abbreviation AS in_org_name,outorg.org_abbreviation AS out_org_name,he.employee_name, ";
		    str += "outform.receive_state,outform.CREATE_DATE as out_date,outform.added_opr_state as opr_state,CASE outform.added_opr_state WHEN '1' THEN '处理中' WHEN '9' THEN '已处理' ELSE '未处理' END AS oprstate_desc,'仪器附属设备' as mix_type_name  ";
		    str += "FROM gms_device_coll_outform outform ";
		    str += "LEFT JOIN GMS_DEVICE_COLLMIX_FORM mif ON outform.device_mixinfo_id=mif.device_mixinfo_id ";
		    str += "LEFT JOIN gms_device_collapp devapp ON devapp.device_app_id=mif.device_app_id ";
		    str += "left join gms_device_allapp allapp on devapp.device_allapp_id = allapp.device_allapp_id ";
		    str += "LEFT JOIN comm_org_information inorg 	ON outform.in_org_id=inorg.org_id ";
		    str += "LEFT JOIN comm_org_subjection sub ON outform.out_org_id=sub.org_subjection_id ";
		    str += "LEFT JOIN comm_org_information outorg ON outform.out_org_id=outorg.org_id ";
		    str += "LEFT JOIN comm_human_employee he 	ON outform.print_emp_id=he.employee_id ";
		    str += "LEFT JOIN gp_task_project pro ON outform.project_info_no = pro.project_info_no AND pro.bsflag = '0' ";
		    str += "WHERE outform.STATE='9' AND outform.bsflag='0' and allapp.allapp_type = 'S1405' AND outform.project_info_no='"+projectInfoNos+"' ";
		    str += "and exists(select 1 from gms_device_equ_outdetail_added added where added.device_outinfo_id = outform.device_outinfo_id)) ";
	    	str += "where 1=1 ";
	    	if(v_device_app_name!=undefined && v_device_app_name!=''){
	    		str += "and device_app_name like '%"+v_device_app_name+"%' ";
	    	}
	    	if(v_mixinfo_no!=undefined && v_mixinfo_no!=''){
	    		str += "and outinfo_no like '%"+v_mixinfo_no+"%' ";
	    	}
	    	if(v_opr_state!=undefined && v_opr_state!=''){
				if(v_opr_state == '1'){//处理中
					str += "and opr_state = '1' ";
				}else if(v_opr_state == '9'){//已处理
					str += "and opr_state = '9' ";
				}else{//未处理
					str += "and ((opr_state != '1' and opr_state != '9' ) or opr_state is null) ";
				}					
			}
	    	if(v_allapp_type!=undefined && v_allapp_type!=''){
				if(v_allapp_type == '0'){//专业化震源
					str += "and mix_type_id = 'S0623' ";
				}else if(v_allapp_type == '1'){//专业化测量
					str += "and mix_type_id = 'S1404' ";
				}else if(v_allapp_type == '2'){//专业化仪器
					str += "and mix_type_id = 'S1405' ";
				}else if(v_allapp_type == '3'){//仪器附属设备
					str += "and mix_type_id = 'S9995' ";
				}				
			}
	    	str += " order by opr_state nulls first,create_date desc ";
	    
		cruConfig.queryStr = str;
		queryData(cruConfig.currentPage);
	}
	
	var selectedTagIndex = 0;
	var showTabBox = document.getElementById("tab_box_content0");
	
    //chooseOne()函式，參數為觸發該函式的元素本身   
    function chooseOne(cb){   
        var obj = document.getElementsByName("rdo_entity_id");   
        for (i=0; i<obj.length; i++){   
            if (obj[i]!=cb) obj[i].checked = false;   
            else obj[i].checked = true;   
        }   
    }   

    function loadDataDetail(shuaId){
    	var retObj;
    	var ids;
    	if(shuaId!=null){
			ids = shuaId.split("~")[0];
		}else{
			ids = getSelIds('selectedbox');
		    if(ids==''){ 
			    alert("请先选中一条记录!");
	     		return;
		    }
		}
		var info = shuaId.split("~");
		
    	var mainsql="";
    	if(info[1]!='S1405' && info[1]!='S9995'){
        	mainsql ="select devapp.device_app_name,outform.device_outinfo_id,outform.outinfo_no,outform.PROJECT_INFO_NO,pro.project_name, "+
    		"inorg.org_abbreviation as in_org_name,outorg.org_abbreviation as out_org_name,"+
    		"he.employee_name,outform.receive_state,outform.out_date, "+
    		"case outform.opr_state when '1' then '处理中' when '9' then '已处理' else '未处理' end as oprstate_desc,mif.mix_type_id "+
    		"from gms_device_equ_outform outform "+
    		"left join gms_device_mixinfo_form mif on outform.device_mixinfo_id=mif.device_mixinfo_id "+
    		"left join gms_device_app devapp on devapp.device_app_id=mif.device_app_id "+
    		"left join gp_task_project pro on outform.project_info_no=pro.project_info_no "+
    		"left join comm_org_information inorg on outform.in_org_id=inorg.org_id "+
    		"left join comm_org_subjection sub on outform.out_org_id=sub.org_subjection_id left join comm_org_information outorg on sub.org_id=outorg.org_id "+
    		"left join comm_human_employee he on outform.print_emp_id=he.employee_id "+
    		"where outform.device_outinfo_id='"+info[0]+"'";
        }else{
        	mainsql ="select outform.out_date,devapp.device_app_name,outform.device_outinfo_id,outform.outinfo_no,outform.PROJECT_INFO_NO,pro.project_name, "+
    		"inorg.org_abbreviation as in_org_name,outorg.org_abbreviation as out_org_name,"+
    		"he.employee_name,outform.receive_state, ";
    		if(info[1] == 'S9995'){
    			mainsql += "case outform.added_opr_state when '1' then '处理中' when '9' then '已处理' else '未处理' end as oprstate_desc ";
        	}else{
        		mainsql += "case outform.opr_state when '1' then '处理中' when '9' then '已处理' else '未处理' end as oprstate_desc ";
        	}
    		mainsql += "from gms_device_coll_outform outform "+
    		"left join gms_device_collmix_form mif on outform.device_mixinfo_id=mif.device_mixinfo_id "+
    		"left join gms_device_collapp devapp on devapp.device_app_id=mif.device_app_id "+
    		"left join gp_task_project pro on outform.project_info_no=pro.project_info_no "+
    		"left join comm_org_information inorg on outform.in_org_id=inorg.org_id "+
    		"left join comm_org_information outorg on outform.out_org_id=outorg.org_id "+
    		"left join comm_human_employee he on outform.print_emp_id=he.employee_id "+
    		"where outform.device_outinfo_id='"+info[0]+"'";
           }
    	var proqueryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+mainsql);
		retObj = proqueryRet.datas;
		//选中这一条checkbox
		$("input[type='checkbox'][name='selectedbox'][id='selectedbox_"+retObj[0].device_outinfo_id+"~"+info[1]+"']").attr("checked",'true');
		//取消其他选中的
		$("input[type='checkbox'][name='selectedbox'][id!='selectedbox_"+retObj[0].device_outinfo_id+"~"+info[1]+"']").removeAttr("checked");
		//------------------------------------------------------------------------------------
		document.getElementById("dev_project_name").value =retObj[0].project_name;
		document.getElementById("dev_mixinfo_no").value =retObj[0].outinfo_no;
		document.getElementById("dev_in_org").value =retObj[0].in_org_name;
		document.getElementById("dev_out_org").value =retObj[0].out_org_name;
		document.getElementById("dev_print_emp").value =retObj[0].employee_name;
		
		document.getElementById("dev_create_date").value =retObj[0].out_date;
		document.getElementById("dev_state").value =retObj[0].oprstate_desc;
		//重新加载当前标签页信息
		getContentTab(undefined,selectedTagIndex);
    }
    function toDetailPage(){
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
    	var mixId = shuaId.split("~")[1];
		if(mixId=='S1405'){
			window.location.href='<%=contextPath%>/rm/dm/collDevReceive/collSubDevReceiveList_dg.jsp?outInfoId='+shuaId+'&sonFlag='+sonFlag;
		}else if(mixId=='S9995'){//仪器附属设备
			window.location.href='<%=contextPath%>/rm/dm/EqDevReceiveAdded/subDevReceiveList.jsp?mixId='+shuaId+'&sonFlag='+sonFlag;
		}else{
			window.location.href='<%=contextPath%>/rm/dm/EqDevReceive/subDevReceiveList.jsp?mixId='+shuaId+'&sonFlag='+sonFlag;
		}
    }

	function dbclickRow(shuaId){
		var mixId = shuaId.split("~")[1];
		if(mixId=='S1405'){
			window.location.href='<%=contextPath%>/rm/dm/collDevReceive/collSubDevReceiveList_dg.jsp?outInfoId='+shuaId+'&sonFlag='+sonFlag;
		}else if(mixId=='S9995'){//仪器附属设备
			window.location.href='<%=contextPath%>/rm/dm/EqDevReceiveAdded/subDevReceiveList.jsp?mixId='+shuaId+'&sonFlag='+sonFlag;
		}else{
			window.location.href='<%=contextPath%>/rm/dm/EqDevReceive/subDevReceiveList.jsp?mixId='+shuaId+'&sonFlag='+sonFlag;
		}

	}
</script>
</html>
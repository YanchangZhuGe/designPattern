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

  <title>单项目-设备接收-大港设备接收(自有设备)</title> 
 </head> 
 
 <body style="background:#fff" onload="refreshData()">
      	<div id="list_table">
			<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td class="ali_cdn_name">申请单名称</td>
			    <td class="ali_cdn_input">
			    <input id="s_device_app_name" name="s_device_app_name" type="text" />
			     <input type='hidden' id="szButton" name="szButton" value=""/>
			    </td>
			    <td class="ali_cdn_name">调配单号</td>
			    <td class="ali_cdn_input"><input id="s_mixinfo_no" name="s_mixinfo_no" type="text" /></td>
			    <td class="ali_cdn_name">设备类型</td>
			   <td class="ali_cdn_input">
			    	<select id="s_allapp_type" name="s_allapp_type" class="select_width" >
			    	    <option value="" selected="selected">--请选择--</option>
						<option value="0">单台</option>
						<option value="1">批量</option>
						<option value="2">检波器</option>
						<option value="3">仪器附属</option>
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
			   <!-- <auth:ListButton functionId="" id="sz"  css="sz" event="onclick='toShuman()'" title="选择父项目人员"></auth:ListButton> -->
			    <auth:ListButton functionId="" css="jh" event="onclick='toDetailPage()'" title="接收"></auth:ListButton>
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
			     <tr id='device_mixinfo_id_{device_mixinfo_id}' name='device_mixinfo_id'>
			     	<td class="bt_info_even" exp="<input type='checkbox' name='selectedbox' value='{device_mixinfo_id}~{mix_type_id}~{device_app_id}~{device_outinfo_id}' id='selectedbox_{device_mixinfo_id}~{mix_type_id}' />" >选择</td>
					<td class="bt_info_odd" autoOrder="1">序号</td>
					<td class="bt_info_even" exp="{device_app_name}">申请单名称</td>
					<td class="bt_info_odd" exp="{outinfo_no}">调配(出库)单号</td>
					<td class="bt_info_even" exp="{in_org_name}">转入单位</td>
					<td class="bt_info_even" exp="{out_org_name}">转出单位</td>
					<td class="bt_info_odd" exp="{employee_name}">开据人</td>
					<td class="bt_info_even" exp="{allapp_type_name}">设备类型</td>
					<td class="bt_info_even" exp="{create_date}">调配时间</td>
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
				<td class="inquire_item6">调配时间</td>
				<td class="inquire_form6"><input id="dev_create_date" name="" class="input_width" type="text" /></td>
			  </tr>
			  <tr>
				<td class="inquire_item6">处理状态</td>
				<td class="inquire_form6"><input id="dev_state" name="" class="input_width" type="text" /></td>
			  </tr>
			</table>
				</div>
				<div id="tab_box_content1" name="tab_box_content1" idinfo="" class="tab_box_content" style="display:none">
					<table border="0" cellpadding="0" cellspacing="0"  class="tab_line_height" width="100%" style="margin-top:10px;background:#efefef"> 
						<tr class="bt_info" style="display:none" id="S99960000" >
				    		<td class="bt_info_even" width="5%">序号</td>
				        	<td class="bt_info_odd" width="15%">设备编号</td>
							<td class="bt_info_even" width="11%">设备名称</td>
							<td class="bt_info_odd" width="11%">规格型号</td>
							<td class="bt_info_even" width="10%">自编号</td>
							<td class="bt_info_odd" width="9%">牌照号</td>
							<td class="bt_info_even" width="11%">实物标识号</td>
							<td class="bt_info_odd" width="13%">计划进场时间</td>
							<td class="bt_info_even" width="13%">计划离场时间</td>
				        </tr>
				        <tr class="bt_info" style="display:none" id="S9997">
				    		<td class="bt_info_odd" width="5%">序号</td>
							<td class="bt_info_even" width="32%">设备名称</td>
							<td class="bt_info_odd" width="32%">规格型号</td>
							<td class="bt_info_even" width="15%">出库数量</td>
							<td class="bt_info_odd" width="16%">接收状态</td>							
				        </tr>
				        <tr class="bt_info" style="display:none" id="S14050208">
				    		<td class="bt_info_even" width="5%">序号</td>
							<td class="bt_info_odd" width="24%">设备名称</td>
							<td class="bt_info_even" width="23%">规格型号</td>
							<td class="bt_info_odd" width="11%">单位</td>
							<td class="bt_info_even" width="11%">调配数量</td>
							<td class="bt_info_odd" width="13%">计划进场时间</td>
							<td class="bt_info_even" width="13%">计划离场时间</td>
				        </tr>							
				        
				        <tbody id="detailMap" name="detailMap" ></tbody>
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
	function getContentTab(obj,	index) { 
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
				currentid = currentid.split("~");
			}
		});
		
		if(index == 1){
			//动态查询明细
			var idinfo = $(filterobj).attr("idinfo");
			if(currentid != undefined && idinfo == currentid){
				//已经有值，且完成钻取，那么不再钻取
			}else{
				if(currentid[1]=='S9997' ){
					var prosql = "select '1' as type,'' as asset_coding,null as dev_plan_start_date,null as dev_plan_end_date,'' as self_num,'' as dev_sign,'' as license_num,'调配出库' as showtype,cos.device_name as dev_name,cos.device_model as dev_model,cos.out_num,cos.receive_state,";
					prosql += "case cos.receive_state when '0' then '未接收' when '1' then '接收完毕' when '9' then '接收中' when 'U' then '' else '异常状态' end as recstate_desc ";
					prosql += "from gms_device_coll_outsub cos ";
					prosql += "left join gms_device_coll_outform cof on cos.device_outinfo_id=cof.device_outinfo_id ";
					prosql += "where cof.device_outinfo_id='"+currentid[3]+"'";
					prosql += "union ";
					prosql += "(select '3' as type,'' as asset_coding,null as dev_plan_start_date,null as dev_plan_end_date,'' as self_num,'' as dev_sign,'' as license_num,'补充出库' as showtype,cos.device_name as dev_name,cos.device_model as dev_model,cos.out_num,cos.receive_state,";
					prosql += "case cos.receive_state when '0' then '未接收' when '1' then '接收完毕' when '9' then '接收中' when 'U' then '' else '异常状态' end as recstate_desc ";
					prosql += "from gms_device_coll_outsubadd cos ";
					prosql += "left join gms_device_coll_outform cof on cos.device_outinfo_id=cof.device_outinfo_id ";
					prosql += "where cof.device_outinfo_id='"+currentid[3]+"' and device_mif_subid is null) ";
					//prosql += "union ";
					//prosql += "(select '3' as type,eq.asset_coding,eq.dev_plan_start_date,eq.dev_plan_end_date,eq.self_num,eq.dev_sign,eq.license_num,'补充出库' as showtype,acc.dev_name,acc.dev_model, 1 as out_num,";
					//prosql += "eq.state as receive_state,case eq.state when '1' then '接收中' ";
					//prosql += "when '9' then '接收完毕' else '未接收' end as recstate_desc ";
					//prosql += "from gms_device_equ_outdetail_added eq left join gms_device_account acc ";
					//prosql += "on eq.dev_acc_id=acc.dev_acc_id ";
					//prosql += "where eq.device_outinfo_id='"+currentid[3]+"')";
					}else if(currentid[1]=='S9996'){
						var	prosql = "(select '3' as type,eq.asset_coding,eq.dev_plan_start_date,eq.dev_plan_end_date,eq.self_num,eq.dev_sign,eq.license_num,'补充出库' as showtype,acc.dev_name,acc.dev_model, 1 as out_num,";
						prosql += "eq.state as receive_state,case eq.state when '1' then '接收中' ";
						prosql += "when '9' then '接收完毕' else '未接收' end as recstate_desc ";
						prosql += "from gms_device_equ_outdetail_added eq left join gms_device_account acc ";
						prosql += "on eq.dev_acc_id=acc.dev_acc_id ";
						prosql += "where eq.device_outinfo_id='"+currentid[3]+"')";
					}else if(currentid[1]=='S14050208'){
						var prosql = "select info.dev_name as dev_name,info.dev_model as dev_type,det.coding_name,d.apply_num,";
						prosql += "t.assign_num,d.plan_start_date,d.plan_end_date ";
						prosql += "from gms_device_appmix_main t left join gms_device_app_detail d on t.device_app_detid = d.device_app_detid ";
						prosql += "left join comm_coding_sort_detail det on d.unitinfo = det.coding_code_id left join gms_device_collectinfo info ";
						prosql += "on t.dev_ci_code = info.device_id where t.device_mixinfo_id ='"+currentid[0]+"'";
					}else{
						var prosql = "select amd.dev_acc_id, amd.asset_coding,amd.dev_plan_start_date,amd.dev_plan_end_date,pro.project_name, ";
						prosql += "amd.self_num, amd.dev_sign, amd.license_num, amd.state,account.dev_name,account.dev_model ";
						prosql += "from gms_device_appmix_detail amd ";
						prosql += "left join gms_device_account account on amd.dev_acc_id=account.dev_acc_id ";
						prosql += "left join gms_device_appmix_main amm on amd.device_mix_subid=amm.device_mix_subid ";
						prosql += "left join gms_device_mixinfo_form mif on amm.device_mixinfo_id=mif.device_mixinfo_id ";
						prosql += "left join gp_task_project pro on pro.project_info_no=mif.project_info_no ";
						prosql += "where mif.device_mixinfo_id='"+currentid[0]+"'";
				}
				
				var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+prosql+'&pageSize=10000');
					basedatas = queryRet.datas;
				if(basedatas!=undefined && basedatas.length>=1){
					//先清空
					var filtermapid = "#detailMap";
					$(filtermapid).empty();
					appendDataToDetailTab(filtermapid,basedatas,currentid[1]);
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
	 function chooseOne(cb){   
	        var obj = document.getElementsByName("rdo_entity_id");   
	        for (i=0; i<obj.length; i++){   
	            if (obj[i]!=cb) obj[i].checked = false;   
	            else obj[i].checked = true;   
	        }   
	    } 
	function appendDataToDetailTab(filterobj,datas,type){
		$("#S99960000").css("display","none");
		$("#S9997").css("display","none");
		$("#S14050208").css("display","none");
		
		for(var i=0;i<basedatas.length;i++){
			if(type == 'S9997'){
				$("#S9997").css("display","block");
				
				var innerHTML = "<tr>";
				innerHTML += "<td>"+(i+1)+"</td><td>"+datas[i].dev_name+"</td><td>"+datas[i].dev_model+"</td>";
				innerHTML += "<td>"+datas[i].out_num+"</td><td>"+datas[i].recstate_desc+"</td>";
				innerHTML += "</tr>";
			}else if(type == 'S14050208'){
				$("#S14050208").css("display","block");
				
				var innerHTML = "<tr>";
				innerHTML += "<td>"+(i+1)+"</td><td>"+datas[i].dev_name+"</td><td>"+datas[i].dev_type+"</td>";
				innerHTML += "<td>"+datas[i].coding_name+"</td><td>"+datas[i].assign_num+"</td><td>"+datas[i].plan_start_date+"</td>";
				innerHTML += "<td>"+datas[i].plan_end_date+"</td>";
				innerHTML += "</tr>";
			}else{				
				$("#S99960000").css("display","block");
				
				var innerHTML = "<tr>";
				innerHTML += "<td>"+(i+1)+"</td><td>"+datas[i].asset_coding+"</td><td>"+datas[i].dev_name+"</td>";
				innerHTML += "<td>"+datas[i].dev_model+"</td><td>"+datas[i].self_num+"</td><td>"+datas[i].license_num+"</td>";
				innerHTML += "<td>"+datas[i].dev_sign+"</td><td>"+datas[i].dev_plan_start_date+"</td><td>"+datas[i].dev_plan_end_date+"</td>";
				innerHTML += "</tr>";
			}
			
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
		document.getElementById("s_allapp_type").value="";
		document.getElementById("s_opr_state").value="";
    }
	function refreshData(v_device_app_name,v_mixinfo_no,v_opr_state,v_allapp_type){
		
		var str = "select case mix_type_id when 'S0000' then '单台' when 'S14050208' then '检波器' when 'S9997' then '批量' when 'S9996' then '仪器附属' end as allapp_type_name, t.* ";
			str += "from (select dm.mixinfo_no as outinfo_no,dm.mixinfo_no,dm.create_date,dm.mix_type_id,dm.device_mixinfo_id,'' as device_outinfo_id,dm.modifi_date,devapp.device_app_name,devapp.device_app_id,he.employee_name,pro.project_name,inorg.org_abbreviation as in_org_name,";
			str += "case dm.out_org_id when 'C6000052795280' then '小车/运输设备服务中心' else outorg.org_abbreviation end as out_org_name,";
			str += "dm.opr_state,case dm.opr_state when '1' then '处理中' when '9' then '已处理' else '未处理' end as oprstate_desc ";
			str += "from gms_device_mixinfo_form dm ";
			str += "left join gms_device_app devapp on dm.device_app_id=devapp.device_app_id ";  
			str += "left join comm_human_employee he on dm.print_emp_id=he.employee_id ";
			str += "left join comm_org_information inorg on dm.in_org_id=inorg.org_id ";
			str += "left join comm_org_information outorg on outorg.org_id=dm.out_org_id ";
        	str += "left join gp_task_project pro on devapp.project_info_no=pro.project_info_no and pro.bsflag = '0' left join gms_device_allapp allapp on allapp.device_allapp_id = devapp.device_allapp_id ";
			str += "where ( allapp.allapp_type='S0000' or allapp.allapp_type = 'S14050208' ) and dm.state='9' and dm.bsflag='0' and (dm.mixform_type='1' or dm.mixform_type='3') and dm.project_info_no='"+projectInfoNos+"'";
			str += "union all ";
			str += "select cof.outinfo_no,mif.mixinfo_no,mif.create_date,'S9997' as mix_type_id,mif.device_mixinfo_id,cof.device_outinfo_id,cof.modifi_date,devapp.device_app_name,devapp.device_app_id,he.employee_name,pro.project_name,inorg.org_abbreviation as in_org_name,";
			str += "outorg.org_abbreviation as out_org_name,cof.opr_state,case cof.opr_state when '1' then  '处理中' when '9' then '已处理' else '未处理' end as oprstate_desc ";
			str += "from gms_device_coll_outform cof left join gms_device_collmix_form mif on cof.device_mixinfo_id = mif.device_mixinfo_id left join gms_device_app devapp on devapp.device_app_id = mif.device_app_id ";
			str += "left join gms_device_allapp allapp on devapp.device_allapp_id = allapp.device_allapp_id left join comm_human_employee he on cof.print_emp_id = he.employee_id ";
			str += "left join comm_org_information inorg on cof.in_org_id = inorg.org_id left join comm_org_information outorg on cof.out_org_id = outorg.org_id ";
			str += "left join gp_task_project pro on cof.project_info_no = pro.project_info_no and pro.bsflag = '0' ";
			str += "where cof.bsflag = '0' and allapp.allapp_type = 'S9997' and cof.project_info_no='"+projectInfoNos+"' ";
			str += "union all ";
			str += "select cof.outinfo_no,mif.mixinfo_no,mif.create_date,'S9996' as mix_type_id,mif.device_mixinfo_id,cof.device_outinfo_id,cof.modifi_date,devapp.device_app_name,devapp.device_app_id,he.employee_name,pro.project_name,inorg.org_abbreviation as in_org_name,";
			str += "outorg.org_abbreviation as out_org_name,cof.added_opr_state as opr_state,case cof.added_opr_state when '1' then  '处理中' when '9' then '已处理' else '未处理' end as oprstate_desc ";
			str += "from gms_device_coll_outform cof left join gms_device_collmix_form mif on cof.device_mixinfo_id = mif.device_mixinfo_id left join gms_device_app devapp on devapp.device_app_id = mif.device_app_id ";
			str += "left join gms_device_allapp allapp on devapp.device_allapp_id = allapp.device_allapp_id left join comm_human_employee he on cof.print_emp_id = he.employee_id ";
			str += "left join comm_org_information inorg on cof.in_org_id = inorg.org_id left join comm_org_information outorg on cof.out_org_id = outorg.org_id ";
			str += "left join gp_task_project pro on cof.project_info_no = pro.project_info_no and pro.bsflag = '0' ";
			str += "where cof.bsflag = '0' and allapp.allapp_type = 'S9997' and cof.project_info_no='"+projectInfoNos+"' ";
			str += "and exists(select 1 from gms_device_equ_outdetail_added added where added.device_outinfo_id = cof.device_outinfo_id) ) t where 1=1 ";
		if(v_device_app_name!=undefined && v_device_app_name!=''){
			str += "and device_app_name like '%"+v_device_app_name+"%' ";
		}
		if(v_mixinfo_no!=undefined && v_mixinfo_no!=''){
			str += "and mixinfo_no like '%"+v_mixinfo_no+"%' ";
		}
		if(v_opr_state!=undefined && v_opr_state!=''){
			if(v_opr_state == '1'){//处理中
				str += "and t.opr_state = '1' ";
			}else if(v_opr_state == '9'){//已处理
				str += "and t.opr_state = '9' ";
			}else{//未处理
				str += "and ((t.opr_state != '1' and t.opr_state != '9' ) or t.opr_state is null) ";
			}					
		}
		if(v_allapp_type!=undefined && v_allapp_type!=''){
			if(v_allapp_type == '0'){//单台
				str += "and mix_type_id = 'S0000' ";
			}else if(v_allapp_type == '1'){//批量
				str += "and mix_type_id = 'S9997' ";
			}else if(v_allapp_type == '2'){//检波器
				str += "and mix_type_id = 'S14050208' ";
			}else if(v_allapp_type == '3'){//仪器附属
				str += "and mix_type_id = 'S9996' ";
			}				
		}
		str +=" order by t.opr_state nulls first,t.modifi_date desc "
		
		cruConfig.queryStr = str;
		queryData(cruConfig.currentPage);
	}
	
	var selectedTagIndex = 0;
	var showTabBox = document.getElementById("tab_box_content0");  
	
    function loadDataDetail(shuaId){
    	var retObj;
    	var ids;
		if(shuaId!=null){
			ids = shuaId.split("_")[0];
		}else{
			ids = getSelIds('selectedbox');
		    if(ids==''){ 
			    alert("请先选中一条记录!");
	     		return;
		    }
		}
		var info = shuaId.split("~");
		if(info[1]=='S9997' || info[1]=='S9996'){
		//根据ids去查找
			var str = "select cof.device_mixinfo_id,he.employee_name,tp.project_name,inorg.org_abbreviation as in_org_name,outorg.org_abbreviation as out_org_name,";
				str += "cof.create_date,cof.outinfo_no,cof.modifi_date as print_date,cof.device_outinfo_id, ";
				str += "case cof.receive_state when '0' then '未接收' when '1' then '接收中' when '9' then '接收完毕' else '异常状态' end as recstate_desc,";
				if(info[1]=='S9996'){
					str += "case cof.added_opr_state when '1' then '处理中' when '9' then '已处理' else '未处理' end as oprstate_desc ";
				}else{
					str += "case cof.opr_state when '1' then '处理中' when '9' then '已处理' else '未处理' end as oprstate_desc ";
				}
				str += "from gms_device_coll_outform cof  "
				+"left join gp_task_project tp on cof.project_info_no=tp.project_info_no " 
				+"left join comm_human_employee he on cof.print_emp_id=he.employee_id "
				+"left join comm_org_information inorg on cof.in_org_id=inorg.org_id "
				+"left join comm_org_information outorg on cof.out_org_id=outorg.org_id "
				+"where cof.bsflag='0' and cof.device_outinfo_id='"+info[3]+"'";
			var unitRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+str);
				retObj = unitRet.datas;

			$("#dev_project_name").val(retObj[0].project_name);
			$("#dev_outinfo_no").val(retObj[0].outinfo_no);
			$("#dev_mixinfo_no").val(retObj[0].outinfo_no);
			$("#dev_in_org").val(retObj[0].in_org_name);
			$("#dev_out_org").val(retObj[0].out_org_name);
			$("#dev_print_emp").val(retObj[0].employee_name);
			$("#dev_create_date").val(retObj[0].create_date);
			$("#dev_state").val(retObj[0].oprstate_desc);
		}else{
		    //retObj = jcdpCallService("DevCommInfoSrv", "getDevRecInfo", "devrecId="+info[0]);
		    var str = "select he.employee_name,tp.project_name,dm.*,inorg.org_name as in_org_name,outorg.org_name as out_org_name,";
				str += "case dm.opr_state when '1' then '处理中' when '9' then '已处理' else '未处理' end as oprstate_desc from gms_device_mixinfo_form dm ";
				str += "left join gp_task_project tp on dm.project_info_no=tp.project_info_no ";
				str += "left join comm_human_employee he on dm.PRINT_EMP_ID=he.employee_id ";
				str += "left join comm_org_information inorg on dm.in_org_id=inorg.org_id ";
				str += "left join comm_org_information outorg on dm.out_org_id = outorg.org_id ";
				str += "where device_mixinfo_id='"+info[0]+"' ";
				
				var unitRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+str);
				retObj = unitRet.datas;
			$("#dev_project_name").val(retObj[0].project_name);
			$("#dev_outinfo_no").val(retObj[0].mixinfo_no);
			$("#dev_mixinfo_no").val(retObj[0].mixinfo_no);
			$("#dev_in_org").val(retObj[0].in_org_name);
			$("#dev_out_org").val(retObj[0].out_org_name);
			$("#dev_print_emp").val(retObj[0].employee_name);
			$("#dev_create_date").val(retObj[0].create_date);
			$("#dev_state").val(retObj[0].oprstate_desc);
		}
		//取消其他选中的
		$("input[type='checkbox'][name='selectedbox'][id!='selectedbox_"+info[0]+"~"+info[1]+"']").removeAttr("checked");
		//选中这一条checkbox
		$("input[type='checkbox'][name='selectedbox'][id='selectedbox_"+info[0]+"~"+info[1]+"']").attr("checked",'true');
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
		var info = shuaId.split("~" , -1);
		
		if(info[1]=='S9997'){//自有地震仪器
			window.location.href='<%=contextPath%>/rm/dm/collDevReceive/collProSubDevReceiveList_dg.jsp?mixId='+shuaId;
		}else if(info[1]=='S9996'){//自有地震仪器补充单台
			window.location.href='<%=contextPath%>/rm/dm/EqDevReceiveAdded/subProAddDevReceiveList_dg.jsp?mixId='+shuaId;
		}else if(info[1]=='S14050208'){//检波器
			window.location.href='<%=contextPath%>/rm/dm/devReceiveJBQ/devReceiveJBQList_dg.jsp?mixId='+shuaId;
		}else{
			window.location.href='<%=contextPath%>/rm/dm/devReceive/subDevReceiveList.jsp?mixId='+shuaId+'&sonFlag=N';
		}
    }
	function dbclickRow(shuaId){
		var info = shuaId.split("~" , -1);

		if(info[1]=='S9997'){//自有地震仪器
			window.location.href='<%=contextPath%>/rm/dm/collDevReceive/collProSubDevReceiveList_dg.jsp?mixId='+shuaId;
		}else if(info[1]=='S9996'){//自有地震仪器补充单台
			window.location.href='<%=contextPath%>/rm/dm/EqDevReceiveAdded/subProAddDevReceiveList_dg.jsp?mixId='+shuaId;
		}else if(info[1]=='S14050208'){//检波器
			window.location.href='<%=contextPath%>/rm/dm/devReceiveJBQ/devReceiveJBQList_dg.jsp?mixId='+shuaId;
		}else{
			window.location.href='<%=contextPath%>/rm/dm/devReceive/subDevReceiveList.jsp?mixId='+shuaId+'&sonFlag=N';
		}
	}
	function toShuman(){
		var project_father_no=document.getElementById("szButton").value; 
		popWindow('<%=contextPath%>/rm/dm/devReceive/szDevAcceptList.jsp?fatherNo='+project_father_no,'830:600');
	}
</script>
</html>
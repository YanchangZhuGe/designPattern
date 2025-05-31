<%@ page contentType="text/html;charset=utf-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%@taglib uri="wf" prefix="wf"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String devappid = request.getParameter("devappid");

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
  <title>调配调剂项目申请明细页面</title> 
 </head> 
 
 <body style="background:#fff" onload="refreshData()">
      	<div id="list_table">
			<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  </tr>
			  <tr>
			  	<td class="ali_cdn_name">申请单号</td>
			    <td class="ali_cdn_input">
			    	<input id="s_device_app_no" name="s_device_app_no" type="text" class="input_width" />
			    </td>
			    <td class="ali_cdn_name">项目名称</td>
			    <td class="ali_cdn_input">
			    	<input id="s_project_name" name="s_project_name" type="text" class="input_width" />
			    </td>
			    <td class="ali_query">
			    	<span class="cx"><a href="#" onclick="searchDevData()" title="查询"></a></span>
			    </td>
			    <td class="ali_query">
				    <span class="qc"><a href="#" onclick="clearQueryText()" title="清除"></a></span>
			    </td>
			    <td>&nbsp;</td>
			    <auth:ListButton functionId="" css="jh" event="onclick='toMixNumPage()'" title="批次调配"></auth:ListButton>
			    <auth:ListButton functionId="" css="fh" event="onclick='javascript:window.history.back();'" title="返回"></auth:ListButton>
			  </tr>
			</table>
			</td>
			    <td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
			  </tr>
			</table>
			</div>
			<div id="table_box">
			  <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">		
			     <tr id='device_appdet_id_{device_app_detid}' name='device_appdet_id'>
			        <td class="bt_info_odd" exp="<input type='checkbox' name='selectedbox' value='{device_app_detid}' id='selectedbox_{device_app_detid}' onclick='chooseOne(this)'/>" >选择</td>
					<td class="bt_info_even" autoOrder="1">序号</td>
					<td class="bt_info_odd" exp="{project_name}">项目名称</td>
					<td class="bt_info_even" exp="{jobname}">工序</td>
					<td class="bt_info_odd" exp="{teamname}">班组</td>
					<td class="bt_info_odd" exp="{dev_ci_name}">设备名称</td>
					<td class="bt_info_even" exp="{dev_ci_model}">规格型号</td>
					<td class="bt_info_odd" exp="{unitname}">单位</td>
					<td class="bt_info_even" exp="{apply_num}">申请数量</td>
					<td class="bt_info_odd" exp="{employee_name}">申请人</td>
					<td class="bt_info_even" exp="{purpose}">用途</td>
					<td class="bt_info_odd" exp="{plan_start_date}">计划开始时间</td>
					<td class="bt_info_even" exp="{plan_end_date}">计划结束时间</td>
					<td class="bt_info_odd" exp="{record}">已调配次数</td>
					<td class="bt_info_even" exp="{assigned_num}">已调配数量</td>
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
			    <li id="tag3_1"><a href="#" onclick="getContentTab(this,2)">附件</a></li>
			    <li id="tag3_1"><a href="#" onclick="getContentTab(this,3)">审批明细</a></li>
			    <li id="tag3_1"><a href="#" onclick="getContentTab(this,4)">备注</a></li>
			    <li id="tag3_1"><a href="#" onclick="getContentTab(this,5)">分类码</a></li>
			  </ul>
			</div>
			<div id="tab_box" class="tab_box">
				<div id="tab_box_content0" name="tab_box_content0" class="tab_box_content">
					<table id="devdetailMap" name="detailMap" border="0" cellpadding="0" cellspacing="0"  class="tab_line_height" width="100%" style="margin-top:10px;background:#efefef"> 
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
				    <tr>
				     <td  class="inquire_item6">已调配次数：</td>
				     <td  class="inquire_form6"><input id="record" class="input_width" type="text"  value="" disabled/> &nbsp;</td> 
				     <td  class="inquire_item6">&nbsp;已调配数量：</td>
				     <td  class="inquire_form6"><input id="assigned_num" class="input_width" type="text"  value="" disabled/> &nbsp;</td> 
				     <td colspan='2'>&nbsp;</td>
				    </tr>
					</table>
				</div>
				<div id="tab_box_content1" name="tab_box_content1" class="tab_box_content" style="display:none;">
					<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" style="margin-top:2px;" >
				    	<tr class="bt_info">
				            <td class="bt_info_odd" width="5%">序号</td>
							<td class="bt_info_even" width="20%">转入单位</td>
							<td class="bt_info_odd" width="20%">转出单位</td>
							<td class="bt_info_even" width="8%">调配数量</td>
							<td class="bt_info_odd" width="10%">调配人</td>
							<td class="bt_info_even" width="8%">状态</td>
				        </tr>
				        <tbody id="detailMap" name="detailMap" ></tbody>
			        </table>
				</div>
				<div id="tab_box_content2" name="tab_box_content2" class="tab_box_content" style="display:none;">
				
				</div>
				<div id="tab_box_content3" name="tab_box_content3" class="tab_box_content" style="display:none">
					<wf:startProcessInfo  buttonFunctionId="F_OP_002" title=""/>
				</div>
				<div id="tab_box_content4" name="tab_box_content4" class="tab_box_content" style="display:none">
					
				</div>
				<div id="tab_box_content5" name="tab_box_content5" class="tab_box_content" style="display:none">
					
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
		if(index == 1){
			//动态查询明细
			var currentid ;
			$("input[type='checkbox'][name='selectedbox']").each(function(){
				if(this.checked){
					currentid = this.value;
				}
			});
			var idinfo = $(filterobj).attr("idinfo");
			if(currentid != undefined && idinfo == currentid){
				//已经有值，且完成钻取，那么不再钻取
			}else{
				//先进行查询
				var proSql = "select amm.device_mix_id, amm.device_app_detid, amm.project_info_no,";
				proSql += "amm.in_org_id, inorg.org_name as in_org_name, amm.out_org_id, outorg.org_name as out_org_name,";
				proSql += "amm.assign_num, amm.assign_emp_id, emp.employee_name as assign_emp_name, amm.state,";
				proSql += "case amm.state when '0' then '未提交' else '已提交' end as state_desc ";
				proSql += "from gms_device_appmix_main amm ";
				proSql += "left join comm_org_information inorg on amm.in_org_id = inorg.org_id ";
				proSql += "left join comm_org_information outorg on amm.out_org_id = outorg.org_id ";
				proSql += "left join comm_human_employee emp on amm.assign_emp_id = emp.employee_id "; 
				proSql += "where amm.device_app_detid='"+currentid+"' "; 
				var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+proSql);
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
		$(filternotobj).hide();
		$(filterobj).show();
	}
	function appendDataToDetailTab(filterobj,datas){
		for(var i=0;i<basedatas.length;i++){
			var innerHTML = "<tr>";
			innerHTML += "<td>"+(i+1)+"</td><td>"+datas[i].in_org_name+"</td><td>"+datas[i].out_org_name+"</td>";
			innerHTML += "<td>"+datas[i].assign_num+"</td><td>"+datas[i].assign_emp_name+"</td><td>"+datas[i].state_desc+"</td>";
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

	function searchDevData(){
		var v_device_app_no = document.getElementById("s_device_app_no").value;
		var v_project_name = document.getElementById("s_project_name").value;
		refreshData(v_device_app_no, v_project_name);
	}
	
	function refreshData(v_device_app_no,v_project_name){
		var str = "select pro.project_name,det.device_app_detid,det.project_info_no,det.teamid,sd.coding_name as unitname,";
		str += "teamsd.coding_name as teamname,p6.name as jobname,ci.dev_ci_name,ci.dev_ci_model,det.apply_num,det.team,det.purpose,det.employee_id,";
		str += "det.plan_start_date,det.plan_end_date,employee.employee_name,nvl(tmp.assigned_num,0) as assigned_num,nvl(tmp.record,0) as record ";
		str += "from gms_device_app_detail det ";
		str += "left join bgp_p6_activity p6 on det.teamid = p6.object_id ";
		str += "left join comm_coding_sort_detail teamsd on det.team = teamsd.coding_code_id ";
		str += "left join gms_device_app devapp on det.device_app_id = devapp.device_app_id ";
		str += "left join common_busi_wf_middle wfmiddle on wfmiddle.business_id = devapp.device_app_id  ";
		str += "left join gp_task_project pro on det.project_info_no = pro.project_info_no ";
		str += "left join gms_device_codeinfo ci on det.dev_ci_code = ci.dev_ci_code ";
		str += "left join comm_coding_sort_detail sd on det.unitinfo = sd.coding_code_id ";
		str += "left join (select mixmain.device_app_detid,sum(assign_num) as assigned_num,count(1) as record ";
		str += "from gms_device_appmix_main mixmain group by device_app_detid) tmp ";
		str += "on tmp.device_app_detid = det.device_app_detid ";
		str += "left join comm_human_employee employee on det.employee_id = employee.employee_id ";
		str += "where devapp.bsflag='0' and devapp.device_app_id='<%=devappid%>' and wfmiddle.proc_status='3' ";
		if(v_device_app_no!=undefined && v_device_app_no!=''){
			str += "and devapp.v_device_app_no = '"+v_device_app_no+"' ";
		}
		//TODO设置查询条件
		/*
		if(v_project_name!=undefined && v_project_name!=''){
			str += "and project.v_project_name like '"+v_dev_ci_model+"%' ";
		}
		*/
		cruConfig.queryStr = str;
		queryData(cruConfig.currentPage);;
	}
	 function loadDataDetail(device_app_detid){
    	var retObj;
		if(device_app_detid!=null){
			 retObj = jcdpCallService("DevCommInfoSrv", "getDevAppDetailInfo", "deviceappdetid="+device_app_detid);
		}else{
			var ids = getSelIds('selectedbox');
		    if(ids==''){ 
			    alert("请先选中一条记录!");
	     		return;
		    }
		    retObj = jcdpCallService("DevCommInfoSrv", "getDevAppDetailInfo", "deviceappdetid="+ids);
		}
		//选中这一条checkbox
		$("#selectedbox_"+retObj.devicedetailMap.device_app_detid).attr("checked",'true');
		//取消其他选中的
		$("input[type='checkbox'][name='selectedbox'][id!='selectedbox_"+retObj.devicedetailMap.device_app_detid+"']").removeAttr("checked");
		
		//数据回填
		$("#project_name","#devdetailMap").val(retObj.devicedetailMap.project_name);
		$("#team","#devdetailMap").val(retObj.devicedetailMap.teamname);
		$("#purpose","#devdetailMap").val(retObj.devicedetailMap.purpose);
		$("#unitname","#devdetailMap").val(retObj.devicedetailMap.unitname);
		$("#dev_ci_name","#devdetailMap").val(retObj.devicedetailMap.dev_ci_name);
		$("#dev_ci_model","#devdetailMap").val(retObj.devicedetailMap.dev_ci_model);
		$("#plan_start_date","#devdetailMap").val(retObj.devicedetailMap.plan_start_date);
		$("#plan_end_date","#devdetailMap").val(retObj.devicedetailMap.plan_end_date);
		
		$("#apply_num","#devdetailMap").val(retObj.devicedetailMap.apply_num);
		$("#apply_user","#devdetailMap").val(retObj.devicedetailMap.employee_name);
		
		$("#record","#devdetailMap").val(retObj.devicedetailMap.record);
		$("#assigned_num","#devdetailMap").val(retObj.devicedetailMap.assigned_num);
		//重新加载当前标签页信息
		getContentTab(undefined,selectedTagIndex);
    }
    
	function toMixNumPage(){
		var id ;
		$("input[type='checkbox'][name='selectedbox']").each(function(){
			if(this.checked){
				id = this.value;
			}
		});
    	popWindow('<%=contextPath%>/rm/dm/devmix/planMixNum.jsp?device_app_detid='+id);
    }
    function dbclickRow(shuaId){
    	popWindow('<%=contextPath%>/rm/dm/devmix/planMixNum.jsp?device_app_detid='+shuaId);
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
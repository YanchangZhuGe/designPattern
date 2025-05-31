<%@ page contentType="text/html;charset=utf-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%@taglib uri="wf" prefix="wf"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String projectInfoNo = user.getProjectInfoNo();
	 String mixId = request.getParameter("mixId");
	    String[] ids = mixId.split("~");
	    mixId = ids[0];
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

  <title>采集设备接收明细</title> 
 </head> 
 
 <body style="background:#fff" onload="refreshData()">
      	<div id="list_table">
			<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td class="ali_cdn_name">设备名称</td>
			    <td class="ali_cdn_input"><input id="s_dev_name" name="s_dev_name" type="text" /></td>
			    <td class="ali_cdn_name">规格型号</td>
			    <td class="ali_cdn_input"><input id="s_dev_model" name="s_dev_model" type="text" /></td>
			    <td class="ali_query">
				    <span class="cx"><a href="#" onclick="searchDevData()" title="JCDP_btn_query"></a></span>
			    </td>
			    <td>&nbsp;</td>
			    <auth:ListButton functionId="" css="jh" event="onclick='toAdd()'" title="接收"></auth:ListButton>
			    <auth:ListButton functionId="" css="fh" event="onclick='toBack()'" title="JCDP_btn_back"></auth:ListButton>
				
			  </tr>
			</table>
			</td>
			    <td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
			  </tr>
			</table>
			</div>
			<div id="table_box">
			  <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">		
			     <tr id='device_mix_subid_{device_mix_subid}' name='device_oif_subid'>
			     	<td class="bt_info_even" exp="<input type='checkbox' name='selectedbox' value='{device_mix_subid}' id='selectedbox_{device_mix_subid}' recstate='{recstate_desc}' />" >选择</td>
					<td class="bt_info_odd" autoOrder="1">序号</td>
					<td class="bt_info_even" exp="{dev_name}">设备名称</td>
					<td class="bt_info_odd" exp="{dev_type}">规格型号</td>
					<td class="bt_info_even" exp="{coding_name}">计量单位</td>
					<td class="bt_info_odd" exp="{assign_num}">数量</td>
					<td class="bt_info_even" exp="{recstate_desc}">接收状态</td>
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
			    <li id="tag3_3"><a href="#" onclick="getContentTab(this,3)">附件</a></li>
			    <li id="tag3_4"><a href="#" onclick="getContentTab(this,4)">备注</a></li>
			    <li id="tag3_5"><a href="#" onclick="getContentTab(this,5)">分类码</a></li>
			  </ul>
			</div>
			<div id="tab_box" class="tab_box">
				<div id="tab_box_content0" name="tab_box_content0" class="tab_box_content">
					<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
			  <tr>
				<td class="inquire_item6">设备名称</td>
				<td class="inquire_form6"><input id="device_name" name="device_name"  class="input_width" type="text" readonly/></td>
				<td class="inquire_item6">规格型号</td>
				<td class="inquire_form6"><input id="device_model" name="device_model" class="input_width" type="text" readonly/></td>
				<td class="inquire_item6">接收状态</td>
				<td class="inquire_form6"><input id="recstate_desc" name="recstate_desc" class="input_width" type="text" readonly/></td>
			  </tr>
				<tr>
				<td class="inquire_item6">计量单位</td>
				<td class="inquire_form6"><input id="unit_name" name="unit_name" class="input_width" type="text" readonly/></td>
				<td class="inquire_item6">数量</td>
				<td class="inquire_form6"><input id="out_num" name="out_num" class="input_width" type="text" readonly/></td>
			  </tr>
			</table>
				</div>
				<div id="tab_box_content1" name="tab_box_content1" class="tab_box_content" style="display:none">
					
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
		var currentid;
		$("input[type='checkbox'][name='selectedbox']").each(function(i){
			if(this.checked == true){
				currentid = this.value;
			}
		});
		if(index == 3){
			$("#attachement").attr("src","<%=contextPath%>/doc/common/common_doc_list.jsp?relationId="+currentid);
		}else if(index == 4){
			$("#remark").attr("src","<%=contextPath%>/common/remark/relatedOperation.srq?foreignKeyId="+currentid);
		}else if(index == 5){
			$("#codeManager").attr("src","<%=contextPath%>/pm/projectCode/projectCodeAssignment.jsp?owner=5&relationId="+currentid);
		}
		$(filternotobj).hide();
		$(filterobj).show();
	}

$(document).ready(lashen);
</script>
 
<script type="text/javascript">

	cruConfig.contextPath =  "<%=contextPath%>";
	cruConfig.cdtType = 'form';
	var projectInfoNos = '<%=projectInfoNo%>';
	function searchDevData(){
		var v_dev_name = document.getElementById("s_dev_name").value;
		var v_dev_model = document.getElementById("s_dev_model").value;
		refreshData(v_project_name, v_dev_model);
	}
	
	function refreshData(v_dev_name,v_dev_model){
		var str = "select t.device_mix_subid,info.dev_name as dev_name, info.dev_model as dev_type,det.coding_name,d.apply_num,t.assign_num,d.plan_start_date,d.plan_end_date,case when t.state is null then '未接收' when t.state='9' then '已接收' end  as recstate_desc from gms_device_appmix_main t left join gms_device_app_detail d on t.device_app_detid=d.device_app_detid  left join gms_device_collectinfo info on t.dev_ci_code=info.device_id left join comm_coding_sort_detail det on d.unitinfo=det.coding_code_id where t.device_mixinfo_id='<%=mixId%>'";
		
		if(v_dev_name!=undefined && v_dev_name!=''){
			str += "and d.device_name like '%"+v_dev_name+"%' ";
		}
		if(v_dev_model!=undefined && v_dev_model!=''){
			str += "and d.dev_type like '"+v_dev_model+"%' ";
		}
		
		cruConfig.queryStr = str;
		queryData(cruConfig.currentPage);
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
		var str = "select t.device_mix_subid,info.dev_name as dev_name, info.dev_model as dev_type,det.coding_name,d.apply_num,t.assign_num,d.plan_start_date,d.plan_end_date,case when t.state is null then '未接收' when t.state='9' then '已接收' end  as recstate_desc from gms_device_appmix_main t left join gms_device_app_detail d on t.device_app_detid=d.device_app_detid  left join gms_device_collectinfo info on t.dev_ci_code=info.device_id left join comm_coding_sort_detail det on d.unitinfo=det.coding_code_id where t.device_mixinfo_id='<%=mixId%>' ";
		var unitRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+str);
		retObj = unitRet.datas;
		//取消选中框--------------------------------------------------------------------------
		//选中这一条checkbox
		$("#selectedbox_"+retObj[0].device_mix_subid).attr("checked",'true');
		//取消其他选中的
		$("input[type='checkbox'][name='selectedbox'][id!='selectedbox_"+retObj[0].device_mix_subid+"']").removeAttr("checked");
		$("#device_name").val(retObj[0].dev_name);
		$("#device_model").val(retObj[0].dev_type);
		$("#unit_name").val(retObj[0].coding_name);
		$("#recstate_desc").val(retObj[0].recstate_desc);
		$("#out_num").val(retObj[0].assign_num);
		//重新加载当前标签页信息
		getContentTab(undefined,selectedTagIndex);
    }
	//打开新增界面
	function toAdd(){ 
		ids = getSelIds('selectedbox');  
		if(ids==''){
			alert("请选择一条信息!");
			return;
		}
		//如果现在是已接受，那么不能重复接收
		var recstate = $("input[type='checkbox'][name='selectedbox']:checked").attr("recstate");
		if(recstate=="已接收"){
			alert("本设备已接收,请查看!");
			return;
		}
		popWindow('<%=contextPath%>/rm/dm/devReceiveJBQ/devRecieveJBQSubmit_dg.jsp?id='+ids+'&outInfoId=<%=mixId%>'); 
	 } 
	 function toBack(){
	 	window.location.href='<%=contextPath%>/rm/dm/devReceive/ownEqDevReceiveList_dg.jsp';
	 }
</script>
</html>
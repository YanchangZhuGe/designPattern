<%@ page contentType="text/html;charset=utf-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%@taglib uri="wf" prefix="wf"%>
<%
	String contextPath = request.getContextPath();
	String projectInfoNo = request.getParameter("projectInfoNo");
	String devMovId = request.getParameter("devMovId");
	if(projectInfoNo==null||"".equals(projectInfoNo)){
		UserToken user = OMSMVCUtil.getUserToken(request); 
		projectInfoNo= user.getProjectInfoNo();
	}

%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/css/bgpmcs_table.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/pm/bpm/common/processInfoCommon.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open1.js"></script>
  <title>配置计划审批明细页面</title> 
 </head> 
 <body class="bgColor_f3f3f3" onload="refreshData()">
 <form name="form1" id="form1" method="post" action="" target="target_id">
      	<div id="list_table">
			<div id="table_box" style="overflow-y:srcoll;height:550px">
			<fieldSet style="margin-left:2px;width:98%"><legend>申请基本信息</legend>
		      <table border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
		        <tr>
		         <td class="inquire_item4" >转出项目:</td>
		          <td class="inquire_form4" >
		          	<input name="out_project_name" id="out_project_name" class="input_width" type="text"  value="" readonly/>
		          	<input name="out_project_no" id="out_project_no" class="input_width" type="hidden"  value="" readonly/>
		          </td>
		          <td class="inquire_item4" >转入项目:</td>
		          <td class="inquire_form4" >
		          	<input name="in_project_name" id="in_project_name" class="input_width" type="text"  value="" readonly/>
		          	<input name="in_project_no" id="in_project_no" class="input_width" type="hidden"  value="" readonly/>
		          </td>
		          </tr>
		          <tr>
		          <td class="inquire_item4" >申请单号:</td>
		          <td class="inquire_form4" >
		          	<input name="dev_mov_no" id="dev_mov_no" class="input_width" type="text"  value="" readonly/>
		          	<input name="dev_mov_id" id="dev_mov_id" class="input_width" type="hidden"  value="<%=devMovId%>" readonly/>
		          </td>
		          <td class="inquire_item4" >申请单名称:</td>
		          <td class="inquire_form4" >
		          	<input name="dev_mov_name" id="dev_mov_name" class="input_width" type="text"  value="" readonly/>
		          </td>
		        </tr>
		       </table>
		      </fieldSet>
		      <div id="dantaidiv" style="display:none">
			     <fieldSet style="margin-left:2px;width:98%"><legend>设备明细</legend>
				  <table style="width:98%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">		
				     <tr id='device_appdet_id_{device_allapp_detid}' name='device_allapp_detid'>
				     	<td class="bt_info_odd" >序号</td>
						<td class="bt_info_even">设备名称</td>
						<td class="bt_info_odd">规格型号</td>
						<td class="bt_info_even">自编号</td>
						<td class="bt_info_odd">牌照号</td>
						<td class="bt_info_even">实物标识号</td>
						<td class="bt_info_odd">AMIS资产编号</td>
				     </tr>
				     <tbody id="detailList0" name="detailList0"></tbody>
				  </table>
				 </fieldSet>
			 </div>
			<div id="tag-container_3" style="display:block;">
			  <ul id="tags" class="tags">
			    <li class="selectTag" id="tag3_1"><a href="#" onclick="getContentTab(this,2)">审批明细</a></li>
			  </ul>
			</div>
			<div id="tab_box" class="tab_box">
			<div id="tab_box_content1" name="tab_box_content1" class="tab_box_content" style="display:block;">
				<wf:getProcessInfo />
			</div>
			</div>
		 </div>
		 <div id="oper_div" >
	
	<%
	String isDone = request.getParameter("isDone");
	if(isDone == null || !isDone.equals("1")){
		%>
		  <span class="pass_btn" title="审批通过"><a href="#" onclick="submitInfo(1);changeSub(1);"></a></span>
	        <span class="nopass_btn" title="审批不通过"><a href="#" onclick="submitInfo(0);changeSub(0);"></a></span>
		<%
	}
	%>

	

	    </div>
	</div>
</form>
<iframe style="display: none;" id="target_id" name="target_id"></iframe>
</body>
<script type="text/javascript">
	
	function getContentTab(obj,index) { 
		$("LI","#tag-container_3").removeClass("selectTag");
		var contentSelectedTag = obj.parentElement;
		contentSelectedTag.className ="selectTag";

		var filterobj = ".tab_box_content[name=tab_box_content"+index+"]";
		var filternotobj = ".tab_box_content[name!=tab_box_content"+index+"]";
		$(filternotobj).hide();
		$(filterobj).show();
	}
	$(document).ready(lashen);
</script>
 
<script type="text/javascript">

	cruConfig.contextPath =  "<%=contextPath%>";
	cruConfig.cdtType = 'form';
	var projectInfoNos = '<%=projectInfoNo%>';

	function refreshData(){
	
		var str = "select mov.dev_mov_no,mov.out_project_info_id,mov.in_project_info_id,mov.dev_mov_name,outgp.project_name as out_project_name,ingp.project_name as in_project_name, ";
		str+="dui.dev_name,dui.dev_model,dui.self_num,dui.license_num,dui.dev_sign,dui.asset_coding from gms_device_move mov left join ";
		str+="gms_device_move_detail movdet on mov.dev_mov_id=movdet.dev_mov_id left join gms_device_account_dui dui on movdet.dev_acc_id=dui.dev_acc_id ";
		str+="left join gp_task_project outgp on mov.out_project_info_id=outgp.project_info_no left join gp_task_project ingp on ";
		str+="mov.in_project_info_id=ingp.project_info_no where mov.dev_mov_id='<%=devMovId%>' and mov.bsflag='0'";
		var detailRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+str+'&pageSize=10000');
		var retObj = detailRet.datas;
		if(retObj && retObj.length>0){
			for(var index=0;index<retObj.length;index++){
				if(index == 0 ){
					$("#dev_mov_no").val(retObj[index].dev_mov_no);
					$("#dev_mov_name").val(retObj[index].dev_mov_name);
					$("#out_project_name").val(retObj[index].out_project_name);
					$("#in_project_name").val(retObj[index].in_project_name);
					$("#out_project_no").val(retObj[index].out_project_info_id);
					$("#in_project_no").val(retObj[index].in_project_info_id);
				}
				var seqinfo = retObj[index].seqinfo;
				var dev_name = retObj[index].dev_name;
				var dev_model = retObj[index].dev_model;
				var self_num = retObj[index].self_num;
				var license_num = retObj[index].license_num;
				var dev_sign = retObj[index].dev_sign;
				var asset_coding = retObj[index].asset_coding;
				
				//动态新增表格
				var innerhtml = "<tr id='tr"+index+"' name='tr"+index+"' seq='"+index+"'>";
				innerhtml += "<td>"+(index+1)+"</td>";
				innerhtml += "<td>"+dev_name+"</td>";
				innerhtml += "<td>"+dev_model+"</td>";
				innerhtml += "<td>"+self_num+"</td>";
				innerhtml += "<td>"+license_num+"</td>";
				innerhtml += "<td>"+dev_sign+"</td>";
				innerhtml += "<td>"+asset_coding+"</td>";
				innerhtml += "</tr>";
				
				$("#detailList0").append(innerhtml);
			}
			$("#detailList0>tr:odd>td:odd").addClass("odd_odd");
			$("#detailList0>tr:odd>td:even").addClass("odd_even");
			$("#detailList0>tr:even>td:odd").addClass("even_odd");
			$("#detailList0>tr:even>td:even").addClass("even_even");
			$("#dantaidiv").show();
		}
	}
	
	function submitInfo(oprinfo){
		var oprstate;
		if(oprinfo==1){
			oprstate = "pass";
		}else{
			oprstate = "notPass";
		}		
		document.getElementById("isPass").value=oprstate;
		document.getElementById("form1").action = "<%=contextPath%>/rm/dm/toUpStateInfowfpa.srq";
		//document.getElementById("form1").action = "<%=contextPath%>/pm/bpm/common/close_page.jsp";
		
		document.getElementById("form1").submit();
	}
	
	function changeSub(oprinfo){
		var oprstate;
		if(oprinfo==1){
			oprstate = "pass";
		}else{
			oprstate = "notPass";
		}
		if(confirm("确认提交？")){
			document.getElementById("form1").action = "<%=contextPath%>/rm/dm/toSaveDevMoveAuditInfowfpa.srq?oprstate="+oprstate;
			document.getElementById("form1").submit();
		}
		window.setTimeout(function(){window.close();},4000);
	}
</script>
</html>
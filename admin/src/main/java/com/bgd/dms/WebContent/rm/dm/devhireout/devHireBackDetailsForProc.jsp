<%@ page contentType="text/html;charset=utf-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%@taglib uri="wf" prefix="wf"%>
<%
	String contextPath = request.getContextPath();
	String deviceHireOutId = request.getParameter("businessId");
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
			<fieldset style="margin-left:2px;width:98%"><legend>申请基本信息</legend>
		      <table border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
		        <tr>
		          <td class="inquire_item4" >返还单号:</td>
		          <td class="inquire_form4" >
		          	<input name="device_hire_out_no" id="device_hire_out_no" class="input_width" type="text"  value="" readonly/>
		          </td>
		          <td class="inquire_item4" >返还单名称:</td>
		          <td class="inquire_form4" >
		          	<input name="device_hire_out_name" id="device_hire_out_name" class="input_width" type="text"  value="" readonly/>
		          </td>
		        </tr>
		       </table>
		      </fieldset>
		      <div id="dantaidiv" >
			     <fieldset style="margin-left:2px;width:98%"><legend>单台管理设备</legend>
				  <table style="width:98%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">		
				     <tr id='device_appdet_id_{device_allapp_detid}' name='device_allapp_detid'>
				     	<td class="bt_info_odd" >序号</td>
						<td class="bt_info_even">设备名称</td>
						<td class="bt_info_odd">规格型号</td>
						<td class="bt_info_even">牌照号</td>
						<td class="bt_info_odd">自编号</td>
						<td class="bt_info_even">实物标识号</td>
				     </tr>
				     <tbody id="detailList0" name="detailList0"></tbody>
				  </table>
				 </fieldset>
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
		  <span class="pass_btn" title="审批通过"><a href="#" onclick="submitInfo(1)"></a></span>
	        <span class="nopass_btn" title="审批不通过"><a href="#" onclick="submitInfo(0)"></a></span>
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
	var projectInfoNos = "";

	function refreshData(){
	
		var str = "select t.device_hire_out_id,t.device_hire_out_no,t.device_hire_out_name,t.out_date,d.dev_acc_id,d.dev_name,d.dev_model,d.self_num,d.dev_sign,d.license_num from gms_device_hire_out t left join gms_device_hire_out_detail d on t.device_hire_out_id=d.device_hire_out_id where t.device_hire_out_id='<%=deviceHireOutId%>'";
		var detailRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+str+'&pageSize=10000');
		var retObj = detailRet.datas;
		if(retObj && retObj.length>0){
			for(var index=0;index<retObj.length;index++){
				if(index == 0 ){
					$("#device_hire_out_no").val(retObj[index].device_hire_out_no);
					$("#device_hire_out_name").val(retObj[index].device_hire_out_name);
				}
				var dev_acc_id = retObj[index].dev_acc_id;
				var dev_name = retObj[index].dev_name;
				var dev_model = retObj[index].dev_model;
				var self_num = retObj[index].self_num;
				var dev_sign = retObj[index].dev_sign;
				var license_num = retObj[index].license_num;
				
				//动态新增表格
				var innerhtml = "<tr id='tr"+index+"' name='tr"+index+"' seq='"+index+"'>";
				innerhtml += "<td>"+(index+1)+"<input name='dev_acc_id"+index+"' id='v"+index+"' value='"+dev_acc_id+"' type='hidden'/>";
				innerhtml += "<td><input name='devicename"+index+"' id='devicename"+index+"' value='"+dev_name+"' type='text' readonly/></td>";
				innerhtml += "<td><input id='devicetype"+index+"' name='devicetype"+index+"' value='"+dev_model+"'  type='text' readonly/></td>";
				innerhtml += "<td><input name='license_num"+index+"' id='license_num"+index+"' value='"+license_num+"' type='text' readonly/></td>";
				innerhtml += "<td><input id='self_num"+index+"' name='v"+index+"' value='"+self_num+"' type='text' readonly/></td>";
				innerhtml += "<td><input id='dev_sign"+index+"' name='dev_sign"+index+"' value='"+dev_sign+"' type='text' readonly/></td>";
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
		
		var count = $("input[type='text'][name^='devicename']").size();
		document.getElementById("isPass").value=oprstate;
		document.getElementById("form1").action = "<%=contextPath%>/rm/dm/tosaveDevHireBackInfowfpa.srq?count="+count+"&oprstate="+oprstate;
		document.getElementById("form1").submit();
		window.setTimeout(function(){window.close();},2000);
	}
</script>
</html>
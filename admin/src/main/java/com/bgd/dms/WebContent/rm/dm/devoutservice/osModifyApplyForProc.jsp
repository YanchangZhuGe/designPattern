<%@page contentType="text/html;charset=UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="java.util.ResourceBundle"%>
<%@page import="com.bgp.gms.service.rm.dm.constants.DevConstants"%>
<%@taglib prefix="auth" uri="auth"%>
<%@taglib uri="wf" prefix="wf"%>
<%
	String contextPath = request.getContextPath();
	String projectInfoNo = request.getParameter("projectInfoNo");
	String deviceosappid = request.getParameter("deviceosappid");
	UserToken user = OMSMVCUtil.getUserToken(request);
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/css/bgpmcs_table.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" /> 
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<title>报停计划修改界面</title>
</head>
<body class="bgColor_f3f3f3" onload="refreshData();">
<form name="form1" id="form1" method="post" action="">
<div id="new_table_box" style="width:98%">
  <div id="new_table_box_content" style="width:100%">
    <div id="new_table_box_bg" style="width:95%">
      <fieldSet style="margin-left:2px"><legend style="color:#B0B0B0;">报停申请基本信息</legend>
      <table border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
        <tr>
          <td class="inquire_item4" >报停申请单名称:</td>
          <td class="inquire_form4" >
          	<input name="osapp_name" id="osapp_name" class="input_width" type="text" value="" />
          	<input name="project_info_no" id="project_info_no" type="hidden" value="<%=projectInfoNo%>" />
          	<input name="deviceosappid" id="deviceosappid" type="hidden" value="<%=deviceosappid%>" />
          </td>
          <td class="inquire_item4" >报停申请单号:</td>
          <td class="inquire_form4" >
          	<input name="device_osapp_no" id="device_osapp_no" class="input_width" type="text" value="" readonly/>
          </td>
        </tr>
        <tr>
          <td class="inquire_item4" >报停单位:</td>
          <td class="inquire_form4" >
          	<input name="osapp_orgname" id="osapp_orgname" class="input_width" type="text" value="" readonly/>
          	<input name="osapporgid" id="osapporgid" type="hidden" value="" />
          </td>
          <td class="inquire_item4" >报停时间:</td>
          <td class="inquire_form4" >
          	<input name="osappdate" id="osappdate" class="input_width" type="text" value="" readonly/>
          </td>
        </tr>
      </table>
      </fieldSet>
      <div style="width:96%;overflow:auto">
      	<fieldSet style="margin-left:2px"><legend>设备报停明细</legend>
		  <table style="width:98%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
		   <tr>
			<td class="bt_info_odd" width="11%">设备编号</td>
						<td class="bt_info_even" width="11%">设备名称</td>
						<td class="bt_info_odd" width="11%">规格型号</td>
						<td class="bt_info_even" width="8%">单位</td>
						<td class="bt_info_odd" width="8%">数量</td>
						<td class="bt_info_even" width="11%">自编号</td>
						<td class="bt_info_odd" width="11%">实物标识号</td>
						<td class="bt_info_even" width="11%">牌照号</td>
						<td class="bt_info_odd" width="11%">设备所属单位</td>
						<td class="bt_info_even" width="11%">进队日期</td>
						<td class="bt_info_odd" width="11%">报停原因</td>
						<td class="bt_info_even" width="11%">预计报停日期</td>
						<td class="bt_info_odd" width="11%">预计启动日期</td>
		   </tr>
		   <tbody id="processtable0" name="processtable0" >
		   </tbody>
	      </table>
		 </fieldSet>
		 <br/>
		<div id="tab_box_content1" name="tab_box_content1" >
			<wf:getProcessInfo />
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
</div>
</form>
</body>
<script type="text/javascript">
	var projectInfoNo = '<%=projectInfoNo%>';
	var deviceosappid = '<%=deviceosappid%>';
	function refreshData(){
		var retObj;
		var basedatas;
		if('<%=projectInfoNo%>'!=null){
			//查询基本信息
			var querySql = "select pro.project_name,osapp.device_osapp_id,osapp.device_osapp_no,osapp.osapp_name,";
			querySql += "osapp.osapp_org_id,osorg.org_name as osapp_org_name,osapp.osappdate ";
			querySql += "from gms_device_osapp osapp ";
			querySql += "join gp_task_project pro on osapp.project_info_no=pro.project_info_no ";
			querySql += "join comm_org_information osorg on osorg.org_id = osapp.osapp_org_id ";
			querySql += "where pro.bsflag='0' and pro.project_info_no='<%=projectInfoNo%>' and osapp.device_osapp_id='<%=deviceosappid%>'";
			var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql);
			basedatas = queryRet.datas;
		}
		//回填基本信息
		$("#project_name").val(basedatas[0].project_name);
		$("#osappdate").val(basedatas[0].osappdate);
		$("#device_osapp_no").val(basedatas[0].device_osapp_no);
		$("#osapp_name").val(basedatas[0].osapp_name);
		$("#osapporgid").val(basedatas[0].osapp_org_id);
		$("#osapp_orgname").val(basedatas[0].osapp_org_name);
		var retObj;
		if('<%=projectInfoNo%>'!=null){
			//查询明细信息
			var querySql = "select osdet.device_osdet_id,osdet.dev_acc_id,osdet.dev_name,osdet.dev_model,osdet.dev_coding,osdet.self_num,osdet.dev_sign,outorg.org_abbreviation as out_org_name,";
			querySql += "osdet.license_num,osdet.dev_unit,osdet.reason,osdet.start_date,osdet.plan_end_date,osdet.out_org_id,osdet.act_in_time,unitsd.coding_name as unit_name ";
			querySql += "from gms_device_osapp_detail osdet ";
			querySql += "left join gms_device_account_dui dui on osdet.dev_acc_id=dui.dev_acc_id left join comm_org_information outorg  on dui.owning_org_id = outorg.org_id ";
			querySql += "left join comm_coding_sort_detail unitsd on osdet.dev_unit=unitsd.coding_code_id ";
			querySql += "where osdet.devtype='1' and osdet.device_osapp_id='<%=deviceosappid%>'";
			var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql);
			retObj = queryRet.datas;
			
		}
		
		if(retObj!=undefined&&retObj.length>0){
			for(var index=0;index<retObj.length;index++){
				
				var innerhtml = "<tr id='tr"+retObj[index].dev_acc_id+"' name='tr' >";
				innerhtml += "<td>"+retObj[index].dev_coding+"</td>";
				innerhtml += "<td>"+retObj[index].dev_name+"</td>";
				innerhtml += "<td>"+retObj[index].dev_model+"</td>";
				innerhtml += "<td>"+retObj[index].unit_name+"</td>";
				innerhtml += "<td>1</td>";
				innerhtml += "<td>"+retObj[index].self_num+"</td>";
				innerhtml += "<td>"+retObj[index].dev_sign+"</td>";
				innerhtml += "<td>"+retObj[index].license_num+"</td>";
				innerhtml += "<td>"+retObj[index].out_org_name+"</td>";
				innerhtml += "<td>"+retObj[index].act_in_time+"</td>";
				innerhtml += "<td>"+retObj[index].reason;
				innerhtml += "<input name='dev_acc_id"+index+"' value='"+retObj[index].dev_acc_id+"~1' type='hidden'/>";
				innerhtml += "<input name='stop_date"+index+"' value='"+retObj[index].start_date+"' type='hidden'/></td>";
				innerhtml += "<td>"+retObj[index].start_date+"</td>";
				innerhtml += "<td>"+retObj[index].plan_end_date+"</td>";
				innerhtml += "</tr>";
				$("#processtable0").append(innerhtml);
			}
		}
		if('<%=projectInfoNo%>'!=null){
			//查询明细信息
			var querySql = "select osdet.device_osdet_id,osdet.dev_acc_id,osdet.dev_name,osdet.dev_model,osdet.dev_coding,osdet.self_num,osdet.dev_sign,outorg.org_abbreviation as out_org_name,";
			querySql += "osdet.license_num,osdet.dev_unit,osdet.reason,osdet.start_date,osdet.plan_end_date,osdet.out_org_id,osdet.act_in_time,unitsd.coding_name as unit_name,";
			querySql += "osdet.osnum,colldevtype.coding_name as devtypename ";
			querySql += "from gms_device_osapp_detail osdet ";
			querySql += "left join gms_device_account_dui dui on osdet.dev_acc_id=dui.dev_acc_id left join comm_org_information outorg  on dui.owning_org_id = outorg.org_id  ";
			querySql += "left join comm_coding_sort_detail colldevtype on osdet.dev_name=colldevtype.coding_code_id ";
			querySql += "left join comm_coding_sort_detail unitsd on osdet.dev_unit=unitsd.coding_code_id ";
			querySql += "where osdet.devtype='2' and osdet.device_osapp_id='<%=deviceosappid%>'";
			var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql);
			retObj = queryRet.datas;
		}
		if(retObj!=undefined&&retObj.length>0){
			for(var tr_id=0;tr_id<retObj.length;tr_id++){
				//动态新增表格
				var innerhtml = "<tr id='tr"+tr_id+"' name='tr"+tr_id+"' collseq='"+tr_id+"'>";
				innerhtml += "<td>"+retObj[tr_id].dev_coding+"</td>";
				innerhtml += "<td>"+retObj[tr_id].dev_name+"</td>";
				innerhtml += "<td>"+retObj[tr_id].dev_model+"</td>";
				innerhtml += "<td>"+retObj[tr_id].unit_name+"</td>";
				innerhtml += "<td>"+retObj[tr_id].osnum+"</td>";
				innerhtml += "<td>"+retObj[tr_id].self_num+"</td>";
				innerhtml += "<td>"+retObj[tr_id].dev_sign+"</td>";
				innerhtml += "<td>"+retObj[tr_id].license_num+"</td>";
				innerhtml += "<td>"+retObj[tr_id].out_org_name+"</td>";
				innerhtml += "<td>"+retObj[tr_id].act_in_time+"</td>";
				innerhtml += "<td>"+retObj[tr_id].reason+"</td>";
				
				innerhtml += "<input name='colldeviceosdetid"+tr_id+"' value='"+retObj[tr_id].device_osdet_id+"~2' type='hidden'/></td>";
				innerhtml += "<td>"+retObj[tr_id].start_date+"</td>";
				innerhtml += "<td>"+retObj[tr_id].plan_end_date+"</td>";
				innerhtml += "</tr>";
				$("#processtable0").append(innerhtml);
			}
		}
		$("#processtable0>tr:odd>td:odd").addClass("odd_odd");
		$("#processtable0>tr:odd>td:even").addClass("odd_even");
		$("#processtable0>tr:even>td:odd").addClass("even_odd");
		$("#processtable0>tr:even>td:even").addClass("even_even");
	}
	
	function getContentTab(obj,index) {
		$("LI","#tag-container_4").removeClass("selectTag");
		var contentSelectedTag = obj.parentElement;
		contentSelectedTag.className ="selectTag";

		var filterobj = ".tab_box_content[name=tab_box_content"+index+"]";
		var filternotobj = ".tab_box_content[name!=tab_box_content"+index+"]";
		$(filternotobj).hide();
		$(filterobj).show();
		//给关联的按钮给隐藏
		var oprfilterobj = "div[name='oprdiv'][id='oprdiv"+index+"']";
		var oprfilternotobj = "div[name='oprdiv'][id!='oprdiv"+index+"']";
		$(oprfilternotobj).hide();
		$(oprfilterobj).show();
		//给结果区的数据DIV进行控制
		var resfilterobj = "div[name='resultdiv'][id='resultdiv"+index+"']";
		var resfilternotobj = "div[name='resultdiv'][id!='resultdiv"+index+"']";
		$(resfilternotobj).hide();
		$(resfilterobj).show();
	}
	function checkAppNum(obj){
		var re = /^\+?[1-9][0-9]*$/;
		//检查所有的数量字段 
		if(!re.test(obj.value)){
			alert("调配数量必须为数字，且大于0!");
			obj.value = "";
		}
	}
	function submitInfo(oprinfo){
		var oprstate;
		if(oprinfo==1){
			oprstate = "pass";
		}else{
			oprstate = "notPass";
		}
		//保留单台的行信息
		var count = $("input[type='hidden'][name^=dev_acc_id]").size();
		document.getElementById("isPass").value=oprstate;
		document.getElementById("form1").action = "<%=contextPath%>/rm/dm/toSaveDevOSAppAuditInfowfpa.srq?count="+count+"&oprstate="+oprstate;;
		document.getElementById("form1").submit();
		window.setTimeout(function(){window.close();},2000);
	}
</script>
</html>


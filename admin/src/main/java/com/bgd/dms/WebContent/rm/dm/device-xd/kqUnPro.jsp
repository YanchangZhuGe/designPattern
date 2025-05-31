<%@ page contentType="text/html;charset=UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%@ taglib uri="code" prefix="code"%> 
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String dev_appdet_id = request.getParameter("ids");
	
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" /> 
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>

<script type="text/javascript" src="<%=contextPath %>/js/external/jquery.bgiframe-2.1.2.js"></script>
<script type="text/javascript" src="<%=contextPath %>/js/ui/jquery.ui.core.js"></script>
<script type="text/javascript" src="<%=contextPath %>/js/ui/jquery.ui.widget.js"></script>
<script type="text/javascript" src="<%=contextPath %>/js/ui/jquery.ui.mouse.js"></script>
<script type="text/javascript" src="<%=contextPath %>/js/ui/jquery.ui.draggable.js"></script>
<script type="text/javascript" src="<%=contextPath %>/js/ui/jquery.ui.position.js"></script>
<script type="text/javascript" src="<%=contextPath %>/js/ui/jquery.ui.resizable.js"></script>
<script type="text/javascript" src="<%=contextPath %>/js/ui/jquery.ui.dialog.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open1.js"></script>
  <title>设备考勤</title> 
 </head>
<body style="background:#cdddef" onload="refreshData()">
<form name="form1" id="form1" method="post" action="">
<div id="new_table_box" style="width:98%">
  <div id="new_table_box_content" style="width:100%">
    <div id="new_table_box_bg" style="width:95%;overflow:">
      <fieldset><legend>设备考勤</legend>
	  <table width="97%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
		  <tr>
			<td class="inquire_item6" >考勤日期</td>
			<td class="inquire_form6" ><input name="timesheet_date" id="timesheet_date" class="input_width" type="text" onpropertychange = "checkDate()"readonly />
			<img src="<%=contextPath%>/images/calendar.gif" id="tributton3" width='16' height='16' style="cursor: hand;" onmouseover="calDateSelector(timesheet_date,tributton3);"/>
			</td>
			<td class="inquire_item6" ></td>
			<td class="inquire_item6" ></td>
			<td class="inquire_item6" ></td>
			<td class="inquire_item6" ></td>
			<td class="inquire_item6" ></td>
			<td class="inquire_item6" ></td>
		  </tr>
	  </table>
	  
	  </fieldset>
	  <fieldset><legend>设备信息</legend>
	 	<div id="list_table">
		<div id="table_box" >
			<table width="100%" border="0" cellspacing="0" cellpadding="0" align="right" id="queryRetTable" >
				<tr>
					<td class="bt_info_odd" exp="<input name = 'rdo_entity_id'  type='checkbox' value='{dev_acc_id}' onclick='loadDataDetail()'/>" ><input type='checkbox' name='rdo_entity_id' value='' onclick='check()'/></td>
				      <td class="bt_info_even" autoOrder="1">序号</td>
				      <td class="bt_info_odd" exp="{dev_name}">设备名称</td>
				      <td class="bt_info_even" exp="{dev_model}">规格型号</td>
				      <td class="bt_info_odd" exp="{license_num}">牌照号</td>
				      <td class="bt_info_even" exp="{self_num}">自编号</td>
				      <td class="bt_info_odd" exp="{dev_coding}">ERP设备编号</td>
				      <td class="bt_info_odd" exp="<select id = 'kqstate_{dev_acc_id}' name = 'kqstate_{dev_acc_id}'></select>">出勤状态</td>
				</tr>
			</table> 
		</div>
		<table id="fenye_box_table">
		</table>
	</div>
	  </fieldset>
	</div>
	 <div id="oper_div">
     	<span class="bc_btn" ><a id="subButton" href="#" onclick="openMask();submitInfo()"></a></span>
        <span class="gb_btn"><a href="#" onclick="newClose()"></a></span>
    </div>
  </div>
</div>
<div id="dialog-modal" title="正在执行" style="display:none;">
	请不要关闭
</div>
</form>
</body>
<script type="text/javascript"> 
	cruConfig.cdtType = 'form';
	cruConfig.queryStr = "";
	function refreshData(){
		cruConfig.queryService = "DevInsSrv";
		cruConfig.queryOp = "getDevDatas";
		queryData(1);
		initDevStateInfo();
	}
	var checked = false;
	function check(){
			var chk = document.getElementsByName("rdo_entity_id");
			for(var i = 0; i < chk.length; i++){ 
				if(!checked){ 
					chk[i].checked = true; 
				}
				else{
					chk[i].checked = false;
				}
			} 
			if(checked){
				checked = false;
			}
			else{
				checked = true;
			}
		}
	var dev_appdet_id='<%=dev_appdet_id%>';
	function showNewInfo(){
		$("#device_mix_id").val("");
		$("#in_org_name").val($("#in_org_name_info").val());
		$("#in_org_id").val($("#in_org_id_info").val());
		$("#modify_table").show();
	}
	
	
	function submitInfo(){
		var ids = getSelIds("rdo_entity_id");
		if(!checks()){
			return false;
		}
		if (ids == '') {
			alert("请选择一条记录!");
			return;
		}else if(confirm("提交后数据不能修改，确认提交？")){
			//调配数量提交
			document.getElementById("form1").action = "<%=contextPath%>/rm/dm/bgpCommDeviceTimeSheet.srq?state=9&ids="+ids;
			document.getElementById("form1").submit();
		}
	}

	

	function initDevStateInfo(){
			//通过查询结果动态填充资产状态select;
			var querySql="select * from comm_coding_sort_detail where coding_sort_id = '5110000041'";
			var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql);
			datas = queryRet.datas;
			var tab =document.getElementById("queryRetTable");
			var row = tab.rows;
			var appendoption = "";
			if(datas != null){
				for (var i = 0; i< queryRet.datas.length; i++) {
					appendoption += "<option value='"+datas[i].coding_code_id+"'>"+datas[i].coding_name+"</option>";
				}
			}
			for(var i=1;i<row.length;i++){
				var dev_acc_id = row[i].cells[0].firstChild.value;
				$("#kqstate_"+dev_acc_id).append(appendoption);
			}
	}
	function checks(){
		if($("#timesheet_date")[0].value==""){
			alert("考勤日期不可以为空");
			return false;
		}
		return true ;
	}
	function checkDate(){
		var timesheet_date  = document.getElementById("timesheet_date").value;
		timesheet_date = Date.parse(timesheet_date.replace(/-/g,"/"));
		var tab =document.getElementById("queryRetTable");
		var row = tab.rows;
		for(var i=1;i<row.length;i++){
			var actual_out_time = row[i].cells[6].innerHTML;
			if(actual_out_time == "&nbsp;"){
				actual_out_time ="";
			}
			else{
				actual_out_time = Date.parse(actual_out_time.replace(/-/g,"/"));
				}
			var checkobj = row[i].cells[0].firstChild;
			var selectobj = row[i].cells[7].firstChild;
			if(actual_out_time !="" && timesheet_date>actual_out_time){
				$(checkobj).attr("disabled","disabled");
				$(selectobj).attr("disabled","disabled");
			}
			else{
				$(checkobj).removeAttr("disabled");
				$(selectobj).removeAttr("disabled");
			}
		}
		}
	function openMask(){
		$( "#dialog-modal" ).dialog({
			height: 140,
			modal: true,
			draggable: false
		});
	}
</script>
</html>
 
<%@ page contentType="text/html;charset=utf-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String dispose_apply_id = request.getParameter("dispose_apply_id");
    java.util.Calendar c=java.util.Calendar.getInstance();    
    java.text.SimpleDateFormat f=new java.text.SimpleDateFormat("yyyy-MM-dd");   
    String nowTime=f.format(c.getTime());
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" /> 
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<title>报废处置申请录入</title>
</head>
<body class="bgColor_f3f3f3" onload="refreshData();">
<form name="form1" id="form1" method="post"  enctype="multipart/form-data"  action="">
<div id="new_table_box">
  <div id="new_table_box_content">
    <div id="new_table_box_bg">
    <fieldSet style="margin:2px:padding:2px;"><legend>报废处置申请基本信息</legend>
      <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
      	<input name="dispose_apply_id" id="dispose_apply_id" type="hidden" value="<%=dispose_apply_id%>" />
      		<input name="disfiles" id="disfiles" type="hidden" value=""/>
      			<input name="parmeter" id="parmeter" type="hidden" value=""/>
        <tr>
          <td class="inquire_item4">报废处置申请单名称:</td>
          <td class="inquire_form4" colspan="3">
          	<input name="app_name" id="app_name" class="input_width" type="text" value="" readonly/>
          </td>
        </tr>
        <tr>
          <td class="inquire_item4">报废处置申请单号:</td>
          <td class="inquire_form4">
          	<input name="app_no" id="app_no" class="input_width" type="text" value="保存后自动生成.." style="color:#DDDDDD;" readonly/>
          </td>
          <td class="inquire_item4">申请时间:</td>
          <td class="inquire_form4">
          	<input name="apply_date" id="apply_date" class="input_width" type="text" value="<%=nowTime%>" readonly/>
          </td>
        </tr>
        <tr>
          <td class="inquire_item4">申请单位名称:</td>
          <td class="inquire_form4">
          	<input name="org_id" id="org_id" class="input_width" type="hidden" value="<%=user.getOrgId()%>"/>
          	<input name="org_name" id="org_name" class="input_width" type="text" value="<%=user.getOrgName()%>" readonly/>
          </td>
          <td class="inquire_item4">申请人:</td>
          <td class="inquire_form4">
          	<input name="employee_id" id="employee_id" class="input_width" type="hidden" value="<%=user.getEmpId()%>" />
          	<input name="employee_name" id="employee_name" class="input_width" type="text" value="<%=user.getUserName()%>" readonly/>
          </td>
        </tr>
      </table>    
      </fieldSet>
        <fieldSet style="margin-left:2px"><legend>报废处置详细信息</legend>
      	<input name="colnum" id="colnum" class="input_width" type="hidden" value="" readonly/>
		  <div style="overflow:auto">
			  <table style="width:100%"  border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
		       <tr>
					<td class="bt_info_odd" ><input type='checkbox' id='hirechecked'name='hirechecked'/></td>
					<td class="bt_info_even">设备名称</td>
					<td class="bt_info_odd" >规格型号</td>
					<td class="bt_info_even">设备编号</td>
					<td class="bt_info_odd">ERP编码</td>
					<td class="bt_info_even">原值</td>
					<td class="bt_info_odd">净值</td>
					<td class="bt_info_even">报废日期</td>
					<td class="bt_info_odd">备注</td>
				</tr>
				</table>
			   <div style="height:190px;overflow:auto;">
		      	<table style="width:97.9%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
			   		<tbody id="processtable0" name="processtable0" >
			   		</tbody>
		      	</table>
		      </div>
	       </div>
      </fieldSet>
       <fieldSet style="margin:2px:padding:2px;"><legend>其他说明</legend>
      <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
        <tr>
          <td class="inquire_item4">备注:</td>
          <td class="inquire_form4" colspan="3">
            <textarea id="bak" name="bak"  class="textarea" ></textarea>			  
          </td>
        </tr>
            <tr>
			<table id="file_table6" border="0" cellpadding="0" cellspacing="0" class="tab_line_height" width="100%"></table>
        </tr>
      </table>    
      </fieldSet>
	</div>
    <div id="oper_div">
        <span class="gb_btn"><a href="#" onclick="newClose()"></a></span>
    </div>
  </div>
</div>
</form>
</body>
<script type="text/javascript">
$().ready(function(){
	$("#hirechecked").change(function(){
		var checkvalue = this.checked;
		$("input[type='checkbox'][name^='idinfo']").attr('checked',checkvalue);
	});
});

function refreshData(){
	var baseData;
	if('<%=dispose_apply_id%>'!='null'){
		 baseData = jcdpCallService("ScrapeSrv", "getDisposeInfo", "dispose_apply_id="+$("#dispose_apply_id").val());
		$("#app_no").val(baseData.deviceMap.app_no);
		$("#app_name").val(baseData.deviceMap.app_name);
		$("#apply_date").val(baseData.deviceMap.apply_date);
		$("#bak").val(baseData.deviceMap.bak);
		$("#disfiles").val(baseData.deviceMap.disfiles);
		if(baseData.datas!=null)
		{
		for (var tr_id = 0; tr_id< baseData.datas.length; tr_id++) {
			var innerhtml = "<tr id='tr"+tr_id+"' name='tr"+tr_id+"' seq='"+tr_id+"'>";
			innerhtml += "<input name='detdev_ci_code"+tr_id+"' id='detdev_ci_code"+tr_id+"' value='"+baseData.datas[tr_id].scrape_detailed_id+"' size='16'  type='hidden' />";
			innerhtml += "<input name='asset_coding"+tr_id+"' id='asset_coding"+tr_id+"' value='' size='16'  type='hidden' />";
			innerhtml += "<input name='dev_sign"+tr_id+"' id='dev_sign"+tr_id+"' value='' size='16'  type='hidden' />";
			innerhtml += "<input name='producting_date"+tr_id+"' id='producting_date"+tr_id+"' value='' size='16'  type='hidden' />";
			innerhtml += "<input name='license_num"+tr_id+"' id='license_num"+tr_id+"' value='' size='16'  type='hidden' />";
			innerhtml += "<td><input type='checkbox' name='idinfo' id='"+tr_id+"' checked/></td>";
			innerhtml += "<td width='3%'><input name='dev_name"+tr_id+"' id='dev_name"+tr_id+"' style='line-height:15px' value='"+baseData.datas[tr_id].dev_name+"' size='12' type='text' readonly /><img src='<%=contextPath%>/images/magnifier.gif' width='16' height='16' style='cursor:hand;' onclick='showDevCodePage("+tr_id+")' />";
			innerhtml += "</td>";
			innerhtml += "<td><input name='dev_model"+tr_id+"' id='dev_model"+tr_id+"' value='"+baseData.datas[tr_id].dev_model+"' size='10'  type='text' readonly /></td>";
			innerhtml += "<td><input name='dev_type"+tr_id+"' id='dev_type"+tr_id+"' value='"+baseData.datas[tr_id].dev_type+"' size='12' type='text' readonly/>";
			innerhtml += "<td ><input name='dev_coding"+tr_id+"' id='dev_coding"+tr_id+"' value='"+baseData.datas[tr_id].dev_coding+"' size='12' type='text' readonly/></td>";
			innerhtml += "<td ><input name='asset_value"+tr_id+"' id='asset_value"+tr_id+"' value='"+baseData.datas[tr_id].asset_value+"' size='7' type='text' readonly/></td>";
			innerhtml += "<td><input name='net_value"+tr_id+"' id='net_value"+tr_id+"' value='"+baseData.datas[tr_id].net_value+"' size='7' type='text' readonly/></td>";
			innerhtml += "<td ><input name='scrape_date"+tr_id+"' id='scrape_date"+tr_id+"' value='"+baseData.datas[tr_id].scrape_date+"' size='9' type='text' readonly/></td>";
			innerhtml += "<td><input name='bak"+tr_id+"' id='bak"+tr_id+"'  size='7'  type='text' value='"+baseData.datas[tr_id].bak1+"'  readonly/></td>";
			innerhtml += "</tr>";
			$("#processtable0").append(innerhtml);
			}
			$("#processtable0>tr:odd>td:odd").addClass("odd_odd");
			$("#processtable0>tr:odd>td:even").addClass("odd_even");
			$("#processtable0>tr:even>td:odd").addClass("even_odd");
			$("#processtable0>tr:even>td:even").addClass("even_even");
			}
		if(baseData.fdata!=null)
		{
		$("#file_table6").empty();
		for (var tr_id = 1; tr_id<=baseData.fdata.length; tr_id++) {
			insertFile(baseData.fdata[tr_id-1].file_name,baseData.fdata[tr_id-1].file_type,baseData.fdata[tr_id-1].file_id);
		}
		}
}
}

	//插入文件
function insertFile(name,type,id){
	$("#file_table6").append(
			"<tr>"+
			"<td class='inquire_form5'>附件:</td>"+
     			"<td class='inquire_form5' colspan='2' style='text-align:left;'><a href='<%=contextPath%>/doc/downloadDoc.srq?docId="+id+"'>"+name+"</a></td>"+
			"</tr>"
		);
}

</script>
</html>


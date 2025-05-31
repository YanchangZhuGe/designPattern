<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();

	UserToken user = OMSMVCUtil.getUserToken(request);
	String orgId = user.getOrgId();
	String orgSubId = user.getOrgSubjectionId();
	String orgOfSubId = user.getSubOrgIDofAffordOrg();
	String dgFlag = "";
	//判断是否为大港用户(由于大港项目projectType可能有多种，所以使用用户隶属组织机构ID来判断)
	if(orgOfSubId.startsWith("C105007")){
		dgFlag = "Y";
	}else{
		dgFlag = "N";
	}
	String projectType = user.getProjectType();
	String id = request.getParameter("id");
	System.out.println("id == "+id);
	String mixId = request.getParameter("mixId");
	
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
	<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
  <link rel="stylesheet" type="text/css" href="<%=contextPath%>/css/cn/style.css" /> 
  <link href="<%=contextPath%>/css/common.css" rel="stylesheet" type="text/css" /> 
  <link href="<%=contextPath%>/css/main.css" rel="stylesheet" type="text/css" /> 
  <link href="<%=contextPath%>/css/rt_cru.css" rel="stylesheet" type="text/css" /> 
  <link rel="stylesheet" href="<%=contextPath%>/skin/cute/style/style.css" type="text/css" /> 
  <link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" /> 
  <link rel="stylesheet" type="text/css" href="<%=contextPath%>/css/cn/jquery_ui/jquery.ui.all.css" /> 
  <script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script> 
  <script type="text/javascript" src="<%=contextPath%>/js/table.js"></script> 
  <script type="text/javascript" src="<%=contextPath%>/js/ui/jquery.ui.core.js"></script> 
  <script type="text/javascript" src="<%=contextPath%>/js/ui/jquery.ui.widget.js"></script> 
  <script type="text/javascript" src="<%=contextPath%>/js/ui/jquery.ui.mouse.js"></script> 
  <script type="text/javascript" src="<%=contextPath%>/js/ui/jquery.ui.datepicker.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/rt/rt_cru.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/cn/rt_cru_lan.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/rt/proc_base.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/rt/fujian.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/rt/rt_validate.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/cn/rt_validate_lan.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/rt/rt_edit.js"></script>
  <!-- <script type="text/javascript" src="<%=contextPath%>/js/json2.js"></script> -->
  <script type="text/javascript" src="<%=contextPath%>/js/rt/ui_dyAdd.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/dialog_open1.js"></script> 
<title>单项目-设备接收-设备接收(自有单台)-设备接收明细</title>
</head>
<body class="bgColor_f3f3f3" onload="loadDataDetail()">
<form name="form1" id="form1" method="post" action="">
<input type="hidden" id="detail_count" value="" />
<input type="hidden" id="device_mix_detid" name="device_mix_detid"></input>
<input id="mixId" name="mixId"  class="input_width" type="hidden" value="<%=mixId%>" />
<input id="dev_id" name="dev_id"  class="input_width" type="hidden" value="<%=id%>" />
<input type="hidden" id="projectcountry" name="projectcountry"></input>
<div id="new_table_box">
  <div id="new_table_box_content">
    <div id="new_table_box_bg">	     
	    <fieldset style="margin-left:2px"><legend>接收确认信息</legend>
	      <table id="table1" width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
	      <tr  id="inCountry">
			  	<td class="inquire_item4">存放地(省份+库房)</td>
				<td class="inquire_form4" colspan="3">
				<select id="province_in" name="province_in" class="select_width" style="width: 30%;"> 
					<option value="安徽省">安徽省</option>
					<option value="澳门特别行政区">澳门特别行政区</option>
					<option value="北京市">北京市</option>
					<option value="重庆市">重庆市</option>
					<option value="福建省">福建省</option>
					<option value="甘肃省">甘肃省</option>
					<option value="广东省">广东省</option>
					<option value="广西壮族自治区">广西壮族自治区</option>
					<option value="贵州省">贵州省</option>
					<option value="海南省">海南省</option>
					<option value="河北省">河北省</option>
					<option value="黑龙江省">黑龙江省</option>
					<option value="河南省">河南省</option>
					<option value="湖北省">湖北省</option>
					<option value="湖南省">湖南省</option>
					<option value="江苏省">江苏省</option>
					<option value="江西省">江西省</option>
					<option value="吉林省">吉林省</option>
					<option value="辽宁省">辽宁省</option>
					<option value="内蒙古">内蒙古</option>
					<option value="宁夏回族自治区">宁夏回族自治区</option>
					<option value="青海省">青海省</option>
					<option value="陕西省">陕西省</option>
					<option value="山东省">山东省</option>
					<option value="上海市">上海市</option>
					<option value="山西省">山西省</option>
					<option value="四川省">四川省</option>
					<option value="台湾">台湾</option>
					<option value="天津市">天津市</option>
					<option value="香港特别行政区">香港特别行政区</option>
					<option value="新疆维吾尔族自治区">新疆维吾尔族自治区</option>
					<option value="西藏自治区">西藏自治区</option>
					<option value="云南省">云南省</option>
					<option value="浙江省">浙江省</option>
				</select>&nbsp;&nbsp;&nbsp;&nbsp;
				<input id="dev_position_in" name="dev_position_in" class="input_width" type="text" style="width: 60%; float: none;margin-bottom: 7px;height:20px;line-height:20px;"/>
				</td>
			</tr>
	      	<tr>
				<td class="inquire_item4">实际进场时间</td>
				<td class="inquire_form4">
					<input type="text" name="actual_start_date" id="actual_start_date" value="" readonly="readonly" class="input_width" style="height:20px;line-height:20px;"/>
					<img src="<%=contextPath%>/images/calendar.gif" id="tributton1" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(actual_start_date,tributton1);" />
				</td>
			</tr>
		  </table>
	    </fieldset> 
      	 
      	<fieldset style="margin-left:2px"><legend></legend>
      	<div id="tab_box_content1" class="tab_box_content" style="display:none;">
						<table id="yzMap" width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" style="margin-top:2px;" >
					    <tr>   
					  
						<td class="bt_info_odd">序号</td>
						<td class="bt_info_even">设备名称</td>
						<td class="bt_info_odd">规格型号</td>
					    <td class="bt_info_odd">ERP设备编号</td>
						<td class="bt_info_odd">自编号</td>
						<td class="bt_info_even">牌照号</td>
						<td class="bt_info_odd">实物标识号</td>
						<td class="bt_info_odd">计划进场时间</td>
						<td class="bt_info_odd">计划离场时间</td>
					 </tr>	
					<tbody id="assign_body"></tbody>
				</table>
			</div>
      	
      	<div id="table_box">
			<table width="98%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable" >		
			     <tr>
					<td class="bt_info_odd" autoOrder="1">序号</td>
				<td class="bt_info_odd" exp="{dev_name}">设备名称</td>
					<td class="bt_info_even" exp="{dev_model}">规格型号</td>
					<td class="bt_info_odd" exp="{dev_coding}">ERP设备编号</td>
					<td class="bt_info_even" exp="{self_num}">自编号</td>
					<td class="bt_info_odd" exp="{license_num}">牌照号</td>
					<td class="bt_info_even" exp="{dev_sign}">实物标识号</td>
					<td class="bt_info_even" exp="{dev_plan_start_date}">计划进场时间</td>
					<td class="bt_info_odd" exp="{dev_plan_end_date}">计划离场时间</td>
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
			</fieldset>
      	
    </div>
    <div id="oper_div">
     	<span class="tj_btn"><a id="submitButton" href="#" onclick="submitInfo()"></a></span>
        <span class="gb_btn"><a href="#" onclick="newClose()"></a></span>
    </div>
  </div>
</div>
</form>
</body>
<script type="text/javascript"> 

cruConfig.contextPath =  "<%=contextPath%>";
cruConfig.cdtType = 'form';

	
	var devaccId="";
	var projectInfoNo="";
	var projectType="<%=projectType%>";
	var dg_Flag="<%=dgFlag%>";
	var mixId='<%=mixId%>';

	function loadDataDetail(){
		var str ="";
		str += "select t.self_num, t.dev_name, t.dev_sign,t.dev_model,t.dev_coding, t.license_num,d.dev_plan_start_date,d.dev_plan_end_date"+
		" from gms_device_appmix_detail d  left join gms_device_account t on t.dev_acc_id = d.dev_acc_id  where d.device_mix_subid = '"+mixId+"' and d.dev_acc_id in(<%=id%>)";
	cruConfig.queryStr = str;
	queryData(cruConfig.currentPage);
	
	}
	function submitInfo(){
		var province_in=document.getElementById("province_in").value;
		var dev_position_in=document.getElementById("dev_position_in").value;
		var actual_start_date=document.getElementById("actual_start_date").value;
	    if(province_in==""||dev_position_in==""||actual_start_date=="")
		{
	    alert("请输入接收信息!");
		return;    	
		}	  
		if(confirm("确认提交？")){
			document.getElementById("form1").action = "<%=contextPath%>/rm/dm/toSubmitXZReceive.srq";
			document.getElementById("form1").submit();
		}
	}
</script>
</html>


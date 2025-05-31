<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%
	String contextPath = request.getContextPath();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<title>设备入库明细</title>
</head>
<body class="bgColor_f3f3f3" onload="loadDataDetail()">
<form name="form1" id="form1" method="post" action="">
<input type="hidden" id="detail_count" value="" />
<input type="hidden" name="project_info_id" id="project_info_id" />
<input type="hidden" name="device_coll_mixinfo_id" id="device_coll_mixinfo_id" />
<input type="hidden" name="device_coll_backdet_id" id="device_coll_backdet_id" />
<input type="hidden" name="device_acc_id_dui" id="device_acc_id_dui" />
<div id="new_table_box">
  <div id="new_table_box_content">
    <div id="new_table_box_bg">
      <table id="table1" width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
         <tr>
                
				<td class="inquire_item6">设备名称</td>
				<td class="inquire_form6"><input id="dev_name" name="dev_name"  class="input_width" type="text" readonly="readonly" /></td>
				<td class="inquire_item6">规格型号</td>
				<td class="inquire_form6"><input id="dev_model" name="dev_model" class="input_width" type="text" readonly="readonly" /></td>
				<td class="inquire_item6">单位</td>
				<td class="inquire_form6">
					<input id="dev_unit_name" name="dev_unit_name" class="input_width" type="text" readonly="readonly" />
					<input id="dev_unit" name="dev_unit" type="hidden" value=""/>
					<input id="device_id" name="device_id" type="hidden" value=""/>
					<input id="type_id" name="type_id" type="hidden" value=""/>
				</td>
			  </tr>
				<tr>
				<td class="inquire_item6">返还单位</td>
				<td class="inquire_form6">
					<input id="back_org_name" name="back_org_name" class="input_width" type="text" readonly="readonly" />
					<input name="back_org_id" id="back_org_id" class="input_width" type="hidden"/>
				</td>
				
				<td class="inquire_item6">接收单位</td>
				<td class="inquire_form6">
					<input id="receive_org_name" name="receive_org_name" class="input_width" type="text" readonly="readonly" />
					<input name="receive_org_id" id="receive_org_id" class="input_width" type="hidden"/>
				</td>
				<td class="inquire_item6">原所在单位</td>
				<td class="inquire_form6">
					<input id="out_org_name" name="out_org_name" class="input_width" type="text" readonly="readonly" />
					<input name="out_org_id" id="out_org_id" class="input_width" type="hidden"/>
				</td>
				
			  </tr>
			  <tr>
				<td class="inquire_item6">存放地(省份+库房)</td>
				<td class="inquire_form6" colspan="5">
				<select id="province" name="province" class="select_width" style="width: 30%;"> 
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
				<input id="dev_position" name="dev_position" class="input_width" type="text" style="width: 60%; float: none;margin-bottom: 7px;height:20px;line-height:20px;"/>
				</td>
			</tr>
		  <tr>
		  	<td class="inquire_item6">返还数量</td>
			<td class="inquire_form6"><input id="back_num" name="back_num" class="input_width" type="text" readonly="readonly" /></td>
			<td class="inquire_item6"><font color=red>*</font>&nbsp;验收时间</td>
			<td class="inquire_form6" colspan="2"><input id="actual_out_time" name="actual_out_time" class="input_width" type="text" readonly="readonly"/>
				&nbsp;&nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton1" width="16" height="16" style="cursor: hand;"
				onmouseover="calDateSelector(actual_out_time,tributton1);" />
			</td>
			<td></td>
		  </tr>
		  <tr>
		  	<td class="inquire_item6">实际返还数量</td>
			<td class="inquire_form6"><input id="in_num" name="in_num" class="input_width" type="text" readonly="readonly" /></td>
			<!-- <td class="inquire_item6"><a href="#" onclick="viewDetail();" style="text-decoration: underline;color: blue;">查看明细</a></td> -->
			<td colspan="4"></td>
		  </tr>
      </table>
      <fieldset>
      	<legend>设备明细</legend>
      	<div id="table_box">
      	<!-- <table style="width:98.5%" border="0" cellspacing="0" cellpadding="0">
      		<tr>
      			<td>
      				<span class="zj"><a href="#" onclick="toAddDev()"></a></span>
        			<span class="sc"><a href="#" onclick="delDev()"></a></span>
      			</td>
      		</tr>
      	</table> -->
		  <table style="width:99.1%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">		
		     <tr id='device_indetail_id{id}' name='device_indetail_id'>
		     	<td class="bt_info_odd" exp="<input type='checkbox' name='selectedbox' value='{id}' id='selectedbox_{id}'/>" >选择</td>
				<td class="bt_info_even" autoOrder="1">序号</td>
				<td class="bt_info_odd" exp="{dev_name}">设备名称</td>
				<td class="bt_info_even" exp="{dev_model}">规格型号</td>
				<td class="bt_info_odd" exp="{dev_sign}">实物标识号</td>
				<!-- <td class="bt_info_even" exp="{unit_name_desc}">计量单位</td> -->
				<td class="bt_info_even" exp="{owning_org_name}">所属单位</td>
		     </tr> 
		  </table>
		</div>
		<div id="fenye_box"  style="display:block;width: 99%;">
		<table width="99%" border="0" cellspacing="0" cellpadding="0" id="fenye_box_table">
		  <tr>
		    <td align="right">第1/1页，共0条记录</td>
		    <td width="10">&nbsp;</td>
		    <td width="30"><img src="<%=contextPath%>/images/fenye_01.png" width="20" height="20" /></td>
		    <td width="30"><img src="<%=contextPath%>/images/fenye_02.png" width="20" height="20" /></td>
		    <td width="30"><img src="<%=contextPath%>/images/fenye_03.png" width="20" height="20" /></td>
		    <td width="30"><img src="<%=contextPath%>/images/fenye_04.png" width="20" height="20" /></td>
		    <td>到 
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
     	<span class="tj_btn"><a href="#" onclick="submitInfo()"></a></span>
        <span class="gb_btn"><a href="#" onclick="newClose()"></a></span>
    </div>
  </div>
</div>
</form>
</body>
<script type="text/javascript"> 
	var devaccId="";
	var projectInfoNo="";
	var device_backapp_id = "";
	cruConfig.contextPath =  "<%=contextPath%>";
	var device_backdet_id = '<%=request.getParameter("id")%>';
	cruConfig.cdtType = 'form';
	refreshData();
	function refreshData(){
		var str = "select d.id,b.dev_sign,s.device_backdet_id,s.device_coll_backdet_id,s.device_coll_mixinfo_id,b.dev_acc_id,";
		str += "b.dev_name,b.dev_model,i.org_abbreviation owning_org_name,unitsd.coding_name unit_name_desc ";
		str += " from GMS_DEVICE_COLL_BACK_DETAIL s join GMS_DEVICE_RFCOLINFORM_DET d on s.device_coll_backdet_id=d.device_coll_backdet_id ";
		str += " join gms_device_account_b b on d.dev_acc_id=b.dev_acc_id left join comm_coding_sort_detail unitsd on ";
		str += " b.dev_unit = unitsd.coding_code_id left join COMM_ORG_INFORMATION i on b.owning_org_id=i.org_id where ";
		str += " s.device_coll_backdet_id='"+device_backdet_id+"'";
		cruConfig.queryStr = str;
		queryData(cruConfig.currentPage);
	}
	
	function loadDataDetail(){
		var retObj;
		if(device_backdet_id!=null){
			var querySql="select backdet.*,t.device_coll_mixinfo_id,t.device_coll_backdet_id,backfor.project_info_id,";
			querySql += " t.back_num as mixnum,unitsd.coding_name as dev_unit_name,t.dev_acc_id2 device_acc_id_dui,";
			querySql += "accdui.dev_unit,apporg.org_id as apporg_id,apporg.org_abbreviation  as apporg_name,f.receive_org_id as revorg_id,";
			querySql += "revorg.org_abbreviation  as revorg_name,app.project_info_id as project_info_no,accdui.out_org_id,t.in_num,";
			querySql += "oldorg.org_abbreviation  as oldorg_name from GMS_DEVICE_COLL_BACK_DETAIL t left join GMS_DEVICE_COLL_BACKINFO_FORM backfor ";
			querySql += "on t.device_coll_mixinfo_id = backfor.device_coll_mixinfo_id left join gms_device_collbackapp_detail backdet ";
			querySql += " on t.device_backdet_id = backdet.device_backdet_id left join gms_device_collbackapp app";
			querySql += " on app.device_backapp_id = backdet.device_backapp_id left join comm_org_information apporg";
			querySql += " on app.back_org_id = apporg.org_id left join gms_device_coll_account_dui accdui";
			querySql += " on backdet.dev_acc_id = accdui.dev_acc_id left join comm_coding_sort_detail unitsd";
			querySql += " on accdui.dev_unit = unitsd.coding_code_id left join comm_org_information oldorg";
			querySql += " on accdui.out_org_id = oldorg.org_id left join gms_device_coll_backinfo_form f";
			querySql += " on t.device_coll_mixinfo_id = f.device_coll_mixinfo_id left join comm_org_information revorg";
			querySql += " on f.receive_org_id = revorg.org_id where t.device_coll_backdet_id = '"+device_backdet_id+"'";
			var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql);
	        retObj = queryRet.datas;
		}
		
		device_backapp_id = retObj[0].device_coll_mixinfo_id;
		devaccId = retObj[0].dev_acc_id;
		projectInfoNo=retObj[0].project_info_no;
		document.getElementById("dev_name").value =retObj[0].dev_name;
		document.getElementById("dev_model").value =retObj[0].dev_model;
		document.getElementById("dev_unit_name").value =retObj[0].dev_unit_name;
		document.getElementById("device_id").value =retObj[0].device_id;
		document.getElementById("type_id").value =retObj[0].type_id;
		document.getElementById("dev_unit").value =retObj[0].dev_unit;
		document.getElementById("back_org_name").value =retObj[0].apporg_name;
		document.getElementById("back_org_id").value =retObj[0].apporg_id;
		document.getElementById("receive_org_name").value =retObj[0].revorg_name;
		document.getElementById("receive_org_id").value =retObj[0].revorg_id;
		document.getElementById("out_org_name").value =retObj[0].oldorg_name;
		document.getElementById("out_org_id").value =retObj[0].out_org_id;
		document.getElementById("back_num").value =retObj[0].mixnum;
		document.getElementById("in_num").value =retObj[0].in_num;
		document.getElementById("project_info_id").value =retObj[0].project_info_id;
		document.getElementById("device_coll_mixinfo_id").value =retObj[0].device_coll_mixinfo_id;
		document.getElementById("device_coll_backdet_id").value =retObj[0].device_coll_backdet_id;
		document.getElementById("device_acc_id_dui").value =retObj[0].device_acc_id_dui;
	}
	function submitInfo(){
		
		//验证，明细不能为空
		var back_num = $("#back_num").val();
		var in_num = $("#in_num").val();
		in_num = !in_num?0:in_num;
		if(parseInt(in_num)==0){
			alert('请先采集明细数据，再提交表单');
			return false;
		}
		if(parseInt(back_num)-parseInt(in_num)!=0){
			if(!confirm('返回数量【'+back_num+'】与采集数量【'+in_num+'】不相等，确认验收?')){
				return false;
			}
		}
		//返还日期不能为空
		if(''==$("#actual_out_time").val()){
			alert("实际验收时间不能为空");
			return false;
		}
		
		//提交
		var device_backdet_id = '<%=request.getParameter("id")%>';
		document.getElementById("form1").action = "<%=contextPath%>/rm/dm/rfidCollDevIn.srq?device_backdet_id="+device_backdet_id+"&devaccId="+devaccId+"&device_backapp_id="+device_backapp_id+"&projectInfoNo="+projectInfoNo;
		document.getElementById("form1").submit();
		//newClose();
	}
	<%-- function viewDetail(){
		window.showModalDialog("<%=contextPath%>/rm/dm/rfid/devin/rfidCollDevInSubDetail.jsp",{'subid':device_backdet_id});
	} --%>
	function toAddDev(){
		//从队组台账选择设备
		var projectInfoNo = $("#project_info_id").val();
		var device_coll_mixinfo_id = $("#device_coll_mixinfo_id").val();
		var device_coll_backdet_id = $("#device_coll_backdet_id").val();
		var device_acc_id_dui = $("#device_acc_id_dui").val();
		var paramobj = new Object();
		var vReturnValue = window.showModalDialog("<%=contextPath%>/rm/dm/rfid/devin/rfidCollDevInSelectDev.jsp?projectinfono="+projectInfoNo+"&device_backdet_id="+device_backdet_id+"&dui_acc_id="+device_acc_id_dui,paramobj,"dialogWidth=820px;dialogHeight=380px");
		if(vReturnValue == undefined){
			return;
		}
		//var accountidinfos = vReturnValue.split("|","-1");
		//插入明细表，刷新列表
		var p_p = 'ids='+vReturnValue.id+'&main_id='+device_coll_mixinfo_id+'&sub_id='+device_coll_backdet_id+'&did='+vReturnValue.did;
		jcdpCallService('DevCommInfoSrv','saveRfidCollDevInDetail',p_p);
		//refreshData();
		location.href = location.href;
	}
	function delDev(){
		//删除选中的出库设备，可以多选
		var length = 0;
		var selectedid ;
		$("input[type='checkbox'][name='selectedbox']").each(function(i,k){
			if(k.checked){
				if(length==0){
					selectedid = k.value;
				}else{
					selectedid = selectedid + "," + k.value;
				}
				length = length+1;
			}
		});
		if(length==0){
			alert("请选择一条记录！");
			return;
		}
		var _ids = "ids=" + selectedid + "&sub_id=" + $("#device_coll_backdet_id").val();
		jcdpCallService('DevCommInfoSrv','delRfidCollDevInDetail',_ids);
		//refreshData();
		location.href = location.href;
	}
</script>
</html>


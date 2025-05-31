<%@ page contentType="text/html;charset=utf-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%
String contextPath = request.getContextPath();
%>
<!DOCTYPE>
<html>
	<head>
		<title>采集设备台账明细</title>
		<meta charset="UTF-8" />
		<!--[if lt IE 9]>
    		<script src="<%=contextPath%>/js/html5.js"></script>
<![endif]-->
		<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" />
		<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" />
		<link rel="stylesheet" href="<%=contextPath%>/css/cn/style.css" />
		<link href="<%=contextPath%>/css/common.css" rel="stylesheet" />
		<link href="<%=contextPath%>/css/main.css" rel="stylesheet" />
		<link href="<%=contextPath%>/css/rt_cru.css" rel="stylesheet" />
	</head>
	<body class="bgColor_f3f3f3" onload="pageInit()">
		<form name="form1" id="form1" method="post" action="">
			<input type="hidden" id="detail_count" value="" />
			<div id="new_table_box">
				<div id="new_table_box_content">
					<div id="new_table_box_bg">
						<fieldset>
							<legend>
								采集设备基本信息
							</legend>
							<table id="table1" width="100%" border="0" cellspacing="0"
								cellpadding="0" class="tab_line_height">
								<tr>
									<td class="inquire_item6">
										<font color=red>*</font>&nbsp;采集设备名称
									</td>
									<td class="inquire_form6">
										<input id="dev_name" name="dev_name" readonly="readonly"
											class="input_width" type="text" />
										<img id="show-btn" src="<%=contextPath%>/images/magnifier.gif"
											width="16" height="16" style="cursor:hand;"
											onclick="showDevTreePage()" />
										<input id="device_id" name="device_id" class="" type="hidden" />
									</td>
									<td class="inquire_item6">
										计量单位
									</td>
									<td class="inquire_form6">
										<select id="dev_unit" name="dev_unit"' class="select_width">
											<option value="">--请选择--</option>
										</select>
									</td>

								</tr>
								<tr>
									<td class="inquire_item6">
										<font color=red>*</font>&nbsp;采集设备型号
									</td>
									<td class="inquire_form6">
										<input id="dev_model" readonly="readonly" name="dev_model"
											class="input_width" type="text" />
									</td>
									<td class="inquire_item6">
										<font color=red>*</font>&nbsp;所在单位
									</td>
									<td class="inquire_form6">
										<input id="usage_org_name" readonly="readonly"
											name="usage_org_name" class="input_width" type="text" />
										<img src="<%=contextPath%>/images/magnifier.gif" width="16"
											height="16" style="cursor:hand;"
											onclick="showOrgTreePage('usage_org')" />
										<input id="usage_org_id" name="usage_org_id" class=""
											type="hidden" />
									</td>
								</tr>
								<tr>
									<td class="inquire_item6">
										<font color=red>*</font>&nbsp;采集设备类型
									</td>
									<td class="inquire_form6">
										<input id="type_name" readonly="readonly" name="type_name"
											class="input_width" type="text" />
										<input id="type_id" name="type_id" class="" type="hidden" />
									</td>
									<td class="inquire_item6">
										所在位置
									</td>
									<td class="inquire_form6">
										<input id="dev_position" name="dev_position" class="input_width" type="text" />
									</td>
								</tr>
							</table>
						</fieldset>
						<fieldset>
							<legend>
								采集设备数量信息
							</legend>
							<table id="table2" width="100%" border="0" cellspacing="0"
								cellpadding="0" class="tab_line_height">
								<tr>
									<td class="inquire_item6">
										完好数量
									</td>
									<td class="inquire_form6">
										<input id="wanhao_num" name="wanhao_num" class="input_width"
											type="text" onkeyup="checkWanhaoNum(this)"/>
									</td>
									<td class="inquire_item6">
										维修数量
									</td>
									<td class="inquire_form6">
										<input id="weixiu_num" name="weixiu_num" class="input_width"
											type="text" value="0" onkeyup="checkOtherNum(this)"/>
									</td>
								</tr>
								<tr>
									<td class="inquire_item6">
										毁损数量
									</td>
									<td class="inquire_form6">
										<input id="huisun_num" name="huisun_num" class="input_width"
											type="text" value="0" onkeyup="checkOtherNum(this)"/>
									</td>
									<td class="inquire_item6">
										盘亏数量
									</td>
									<td class="inquire_form6">
										<input id="pankui_num" name="pankui_num" class="input_width"
											type="text" value="0" onkeyup="checkOtherNum(this)"/>
									</td>
								</tr>
							</table>
							<hr/>
							<table id="table2" width="100%" border="0" cellspacing="0"
								cellpadding="0" class="tab_line_height">
								<tr>

									<td class="inquire_item6">
										总数量
									</td>
									<td class="inquire_form6">
										<input id="total_num" name="total_num" class="input_width"
											type="text" readonly/>
									</td>
									<td class="inquire_item6">
										闲置数量
									</td>
									<td class="inquire_form6">
										<input id="unuse_num" name="unuse_num" class="input_width"
											type="text" readonly/>
									</td>
								</tr>
								<tr>
									<td class="inquire_item6">
										在用数量
									</td>
									<td class="inquire_form6">
										<input id="use_num" name="use_num" class="input_width"
											type="text" value="0" readonly/>
									</td>
									<td class="inquire_item6">
										其他数量
									</td>
									<td class="inquire_form6">
										<input id="other_num" name="other_num" class="input_width"
											type="text" value="0" readonly/>
									</td>
								</tr>
							</table>
						</fieldset>
					</div>
					<div id="oper_div">
						<span class="tj_btn"><a href="#" onclick="submitInfo()"></a>
						</span>
						<span class="gb_btn"><a href="#" onclick="newClose()"></a>
						</span>
					</div>
				</div>
			</div>
		</form>
	<script src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
	<script src="<%=contextPath%>/js/table.js"></script>
	<script src="<%=contextPath%>/js/ui/jquery.ui.core.js"></script>
	<script src="<%=contextPath%>/js/ui/jquery.ui.widget.js"></script>
	<script src="<%=contextPath%>/js/ui/jquery.ui.mouse.js"></script>
	<script src="<%=contextPath%>/js/ui/jquery.ui.datepicker.js"></script>
	<script src="<%=contextPath%>/js/calendar.js"></script>
	<script src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
	<script src="<%=contextPath%>/js/calendar-setup.js"></script>
	<script src="<%=contextPath%>/js/rt/rt_base.js"></script>
	<script src="<%=contextPath%>/js/rt/rt_cru.js"></script>
	<script src="<%=contextPath%>/js/cn/rt_cru_lan.js"></script>
	<script src="<%=contextPath%>/js/rt/proc_base.js"></script>
	<script src="<%=contextPath%>/js/rt/fujian.js"></script>
	<script src="<%=contextPath%>/js/rt/rt_validate.js"></script>
	<script src="<%=contextPath%>/js/cn/rt_validate_lan.js"></script>
	<script src="<%=contextPath%>/js/rt/rt_edit.js"></script>
	<script src="<%=contextPath%>/js/json2.js"></script>
	<script src="<%=contextPath%>/js/rt/ui_dyAdd.js"></script>
	<script src="<%=contextPath%>/js/gms_list.js"></script>
	<script>var _path='<%=contextPath%>'</script>
	<script src="<%=contextPath%>/js/extjs/adapter/ext/ext-base.js"></script>
	<script src="<%=contextPath%>/js/extjs/ext-all-debug.js"></script>
	<script src="<%=contextPath%>/js/extjs/ext-lang-zh_CN.js"></script>
	<script src="<%=contextPath%>/js/dialog_open1.js"></script>
	<script type="text/javascript">
		function checkWanhaoNum(obj){
			var wanhaoValue = obj.value;
			var re = /^(?:(?:[1-9]\d*)|(?:0))$/;
			if(wanhaoValue==""){
				$("#unuse_num").val("");
				$("#total_num").val("");
				return;
			}
			if(!re.test(wanhaoValue)){
				alert("完好数量必须为数字!");
				obj.value = "";
				$("#unuse_num").val("");
				$("#total_num").val("");
	        	return false;
			}else{
				$("#unuse_num").val(obj.value);
				setTotalNum();
			}
		}
		function checkOtherNum(obj){
			var otherValue = obj.value;
			var re = /^(?:(?:[1-9]\d*)|(?:0))$/;
			if(otherValue==""){
				$("#other_num").val("");
				$("#total_num").val("");
				return;
			}
			if(!re.test(otherValue)){
				alert("其他数量必须为数字!");
				obj.value = "";
				$("#other_num").val("");
				$("#total_num").val("");
	        	return false;
			}else{
				setOtherNum();
				setTotalNum();
			}
		}
		function setOtherNum(){
			if($("#weixiu_num").val()==""||$("#huisun_num").val()==""||$("#pankui_num").val()=="")
				return;
			var otherVal = parseInt($("#weixiu_num").val(),10)+parseInt($("#huisun_num").val(),10)+parseInt($("#pankui_num").val(),10);
			$("#other_num").val(otherVal);
		}
		function setTotalNum(){
			if($("#unuse_num").val()==""||$("#other_num").val()=="")
				return;
			//暂时在用的是0
			var totalVal = parseInt($("#unuse_num").val(),10)+parseInt($("#other_num").val(),10)+parseInt($("#use_num").val(),10);
			$("#total_num").val(totalVal);
		}
	</script>
	<script type="text/javascript">
		function pageInit(){
			var retObj;
			var unitSql = "select sd.coding_code_id,coding_name ";
			unitSql += "from comm_coding_sort_detail sd "; 
			unitSql += "where coding_sort_id ='5110000038' order by coding_code";
			var unitRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+unitSql);
			retObj = unitRet.datas;
			var optionhtml = "";
			for(var index=0;index<retObj.length;index++){
				optionhtml +=  "<option value='"+retObj[index].coding_code_id+"'>"+retObj[index].coding_name+"</option>";
			}
			$("#dev_unit").append(optionhtml);
		}
		function showDevTreePage(){
			var data=window.showModalDialog("<%=contextPath%>/rm/dm/collectTree/collectTreeManager.jsp?ctxmenu=false&inline=true","","dialogWidth:300px; dialogHeight:400px");
			for(var i in data){
				switch(i){
					case 'dev_name':
					case 'dev_model':
					case 'device_id':
					case 'type_name':
					case 'type_id':
					$('#'+i).val(data[i]);
					break; 
				}
			}
		}
		function showOrgTreePage(str){
			var returnValue=window.showModalDialog("<%=contextPath%>/rm/dm/deviceAccount/selectOrgHR.jsp?codingSortId=0110000001","test","");
			
			var strs= new Array(); //定义一数组
			if(!returnValue){
				return;
			}
			strs=returnValue.split("~"); //字符分割
			var names = strs[0].split(":");
			document.getElementById(str+"_name").value = names[1];
			
			var orgId = strs[1].split(":");
			document.getElementById(str+"_id").value = orgId[1];
		}
		function submitInfo(){
			if(document.getElementById("dev_name").value==""){
				alert("请输入采集设备名称");
				return;
			}
			if(document.getElementById("dev_model").value==""){
				alert("请输入采集设备型号");
				return;
			}
			if(document.getElementById("type_name").value==""){
				alert("请输入采集设备类型");
				return;
			}
			if(document.getElementById("usage_org_name").value==""){
				alert("请选择所在单位");
				return;
			}
			var regexp = /^\d+$/ ;
			var totalNum = $("#total_num").val(),unuse_num = $("#unuse_num").val();
			var use_num = $("#use_num").val(),other_num = $("#other_num").val();
			if(totalNum==""){
				alert("请完善数量信息!");
				return false;
			}
			if(regexp.test(totalNum) && regexp.test(unuse_num) && regexp.test(use_num) && regexp.test(other_num)){
				totalNum -= 0 ; unuse_num -= 0 ; use_num -= 0 ; other_num -= 0 ; 
				if(!(totalNum == (unuse_num + use_num + other_num))){
					alert("总数量必须等于闲置数量、在用数量和其他数量之和!");
					return false;
				}
			}else{
				alert("填写数量,请输入数字");
				return false;
			}
			var params = $("#form1").serialize();
			cruConfig.contextPath = '<%=contextPath%>';
			var retObj = jcdpCallService("DevCommInfoSrv","saveCollectDevAccount",params);
			if(retObj.returnCode != 0){
				alert("所在单位已存在此采集设备台账信息,新增失败!");
			}else{
				parent.list.frames[1].location.reload();
				newClose();
			}
		}
	</script>
	</body>
</html>


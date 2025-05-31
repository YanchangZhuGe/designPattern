<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();
	String devaccid = request.getParameter("id");
%>
<!DOCTYPE>
<html>
	<head>
		<title>采集设备台账明细</title>
		<meta charset="UTF-8" />
		<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" />
		<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" />
		<link rel="stylesheet" href="<%=contextPath%>/css/cn/style.css" />
		<link href="<%=contextPath%>/css/common.css" rel="stylesheet" />
		<link href="<%=contextPath%>/css/main.css" rel="stylesheet" />
		<link href="<%=contextPath%>/css/rt_cru.css" rel="stylesheet" />
		<link rel="stylesheet" href="<%=contextPath%>/skin/cute/style/style.css" />
		<link rel="stylesheet" media="all" href="<%=contextPath%>/css/calendar-blue.css" />
		<link rel="stylesheet" href="<%=contextPath%>/css/cn/jquery_ui/jquery.ui.all.css" />
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
										<input id="device_id" name="device_id" type="hidden" />
										<input id="dev_acc_id" name="dev_acc_id" type="hidden" />
									</td>
									<td class="inquire_item6">
										计量单位
									</td>
									<td class="inquire_form6">
										<select id="dev_unit_info" name="dev_unit_info"' class="select_width">
											<option value="">--请选择--</option>
										</select>
										<input id="dev_unit" name="dev_unit" type="hidden" />
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
											type="text" onkeyup="checkWanhaoNum(this)" onblur="checkWanhaoNumBlur(this)"/>
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
								<tr>
									<td class="inquire_item6">
										待报废数量
									</td>
									<td class="inquire_form6">
										<input id="touseless_num" name="touseless_num" class="input_width"
											type="text" value="0" readonly/>
										<input id="tech_id" name="tech_id" type="hidden" value=""/>
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
										<input id="oldtotal_num" name="oldtotal_num" type="hidden" />
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
				//完好的数量必须大于在用数量
				var usenumint = parseInt($("#use_num").val(),10);
				var unuse_num = parseInt(obj.value,10)-usenumint;
				if(unuse_num>=0){
					$("#unuse_num").val(unuse_num);
					setTotalNum();
				}else{
					$("#unuse_num").val("");
					$("#total_num").val("");
				}
			}
		}
		function checkWanhaoNumBlur(obj){
			var wanhaoValue = obj.value;
			var re = /^(?:(?:[1-9]\d*)|(?:0))$/;
			if(wanhaoValue==""){
				$("#unuse_num").val("");
				$("#total_num").val("");
				return;
			}else{
				var usenumint = parseInt($("#use_num").val(),10);
				//完好的数量必须大于在用数量
				if(usenumint>parseInt(obj.value,10)){
					alert("完好数量必须大于在用数量!");
					obj.value = "";
					$("#unuse_num").val("");
					$("#total_num").val("");
				}else{
					var unuse_num = parseInt(obj.value,10)-usenumint;
					$("#unuse_num").val(unuse_num);
					setTotalNum();
				}
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
			//修改界面中，需要给其他数量加上待报废的数量
			var otherVal = parseInt($("#weixiu_num").val(),10)+parseInt($("#huisun_num").val(),10)
							+parseInt($("#pankui_num").val(),10)+parseInt($("#touseless_num").val(),10);
			$("#other_num").val(otherVal);
		}
		function setTotalNum(){
			if($("#unuse_num").val()==""||$("#other_num").val()=="")
				return;
			//在用数量在修改界面中不能变，只能通过返还去减少
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
			$("#dev_unit_info").append(optionhtml);
			var querySql = "select ga.*,gc1.dev_name as dev_type,gc2.dev_name as type_name,";
			querySql += "tech.tech_id,nvl(tech.good_num,0) as wanhao_num,nvl(tech.torepair_num,0) as weixiu_num,";
			querySql += "nvl(tech.touseless_num,0) as touseless_num,nvl(tech.tocheck_num,0) as pankui_num,nvl(tech.destroy_num,0) as huisun_num, ";
			querySql += "usageorg.org_abbreviation as usage_org,unitsd.coding_name as unit_name ";
			querySql += "from gms_device_coll_account ga ";
			querySql += "left join gms_device_coll_account_tech tech on ga.dev_acc_id=tech.dev_acc_id ";
			querySql += "left join gms_device_collectinfo gc1 on ga.device_id=gc1.device_id ";
			querySql += "left join gms_device_collectinfo gc2 on gc1.node_parent_id=gc2.device_id ";
			querySql += "left join comm_org_information usageorg on ga.usage_org_id=usageorg.org_id ";
			querySql += "left join comm_coding_sort_detail unitsd on ga.dev_unit=unitsd.coding_code_id ";
			querySql += "where ga.dev_acc_id = '<%=devaccid%>'";
			var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql);
			if(queryRet.datas && queryRet.datas.length > 0){
				var datas = queryRet.datas[0];
				for(var i in datas){
					$('#'+i).val(datas[i]);
				}
				$("#oldtotal_num").val(datas.total_num);
				$("#dev_unit_info").val(datas.dev_unit);
				$("#usage_org_name").val(datas.usage_org);
			}
		}
		/**
		 * 选择组织机构树
		 */
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
		/**
		 * 提交
		 */
		function submitInfo(){
			if($("#dev_name").val()==""){
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
			var regexp = /^\d+$/;
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
			cruConfig.contextPath = '<%=contextPath%>';
			$("#dev_unit").val($("#dev_unit_info").val());
			var params = $("input","#form1").map(function(){return $(this).attr('id')+"="+$.trim($(this).val())}).get().join("&");
			var retObj = jcdpCallService("DevCommInfoSrv","updateCollectDevAccount",params);
			if(retObj.returnCode != 0){
				alert("您选择的所在单位已存在此采集设备台账信息,修改失败!");
			}else{
				parent.list.frames[1].location.reload();
				newClose();
			}
		}
</script>
	</body>
</html>


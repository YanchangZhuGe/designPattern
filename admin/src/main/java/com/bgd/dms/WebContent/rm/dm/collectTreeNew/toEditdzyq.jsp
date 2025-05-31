<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();
	String devaccid = request.getParameter("id");
	String unuse_num=request.getParameter("unuse_num");
	String total_num=request.getParameter("total_num");
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
										&nbsp;采集设备名称
									</td>
									<td class="inquire_form6">
										<input id="dev_name" name="dev_name" readonly="readonly"
											class="input_width" type="text" />
										<input id="device_id" name="device_id" type="hidden" />
										<input id="dev_acc_id" name="dev_acc_id" type="hidden" />
									</td>
									<td class="inquire_item6">
										计量单位
									</td>
									<td class="inquire_form6">
										<select id="dev_unit_info" name="dev_unit_info"' class="select_width" readonly>
											<option value="">--请选择--</option>
										</select>
										<input id="dev_unit" name="dev_unit" type="hidden" />
									</td>

								</tr>
								<tr>
									<td class="inquire_item6">
										&nbsp;采集设备型号
									</td>
									<td class="inquire_form6">
										<input id="dev_model" readonly="readonly" name="dev_model"
											class="input_width" type="text" />
									</td>
								<td class="inquire_item6">
										&nbsp;所在单位
									</td>
									<td class="inquire_form6">
										<input id="usage_org_name" name="usage_org_name" class="input_width" type="text" readonly/>
										<input id="usage_org_id" name="usage_org_id" class=""
											type="hidden" />
									</td>
								</tr>
								<tr>
									<td class="inquire_item6">
										&nbsp;采集设备类型
									</td>
									<td class="inquire_form6">
										<input id="type_name" readonly="readonly" name="type_name"
											class="input_width" type="text" />
										<input id="type_id" name="type_id" class="" type="hidden" />
									</td>
										<td class="inquire_item6">&nbsp;采集设备所属
									</td>
									<td class="inquire_form6">
										<select id='ifcountry' name='ifcountry' class="input_width" readonly >
											<option value='国内'>国内</option>
											<option value='国外'>国外</option>
										</select>
									</td>
								</tr>
									<tr>
						<td class="inquire_item6">
										&nbsp;<font color=red>*</font>操作类型
									</td>
									<td class="inquire_form6">
										<select id='opertype' name='opertype' class="input_width" onchange="changeopertype()" >
											<option value='0'>修改</option>
											<option value='1'>转资新增</option>
										</select>
									</td>
									<td id="inorgname"  class="inquire_item6" style="display:none;">&nbsp;<font color=red>*</font>转入单位：
									</td>
									<td id="inorgcod"  class="inquire_form6" style="display:none;">
					 <select name ="checkOrg" id="checkOrg" class="selected_width" > 
					 <option value="">请选择</option>
          			<option value="C6000000000042">仪器服务中心</option>
          			<option value="C6000000005551">塔里木作业部</option>
          			<option value="C6000000005538">北疆作业部</option>
          			<option value="C6000000005555">吐哈作业部</option>
          			<option value="C6000000005543">敦煌作业部</option>
          			<option value="C6000000005534">长庆作业部</option>
          			<option value="C6000000007537">辽河作业部</option>
          			<option value="C6000000005547">华北作业部</option>
          				<option value="C6000000005560">新区作业部</option>
          	</select> 
          	</td>
									</tr>
							</table>
						</fieldset>
						<fieldset id="zhuanchu" style="display:none;">
							<legend>
								采集设备转出
							</legend>
							<table id="table2" width="100%" border="0" cellspacing="0"
								cellpadding="0" class="tab_line_height">
								<tr>
			         			<td class="bt_info_odd" colspan='2'>转出设备信息</td>
			         			<td class="bt_info_odd" colspan='2'>设备现状态信息</td>
			         		</tr>
								
								<tr>
									<td class="inquire_item6">
										<font color=red>*</font>完好数量
									</td>
									<td class="inquire_form6">
										<input id="wanhaocut_num" name="wanhaocut_num" class="input_width"
											type="text"  
											onkeyup="checkotherCut(this)" />
									</td>
									<td class="inquire_item6">
									完好数量
									</td>
									<td class="inquire_form6">
										<input id="nwanhao_num" name="nwanhao_num" class="input_width"
											type="text"   readonly
											/>
											<input id="nwanhao_num1" name="nwanhao_num1" class="input_width"
											type="hidden" />
									</td>
								</tr>
								<tr>
									<td class="inquire_item6">
										<font color=red>*</font>待报废数量
									</td>
									<td class="inquire_form6">
										<input id="touselesscut_num" name="touselesscut_num" class="input_width"
											type="text"  
											onkeyup="checkotherCut(this)" />
									</td>
									<td class="inquire_item6">
									待报废数量
									</td>
									<td class="inquire_form6">
										<input id="ntouseless_num" name="ntouseless_num" class="input_width"
											type="text"   readonly
											/>
											<input id="ntouseless_num1" name="ntouseless_num1" class="input_width"
											type="hidden" />
											
									</td>
								</tr>
								<tr>
									<td class="inquire_item6">
										<font color=red>*</font>待修数量
									</td>
									<td class="inquire_form6">
										<input id="weixiucut_num" name="weixiucut_num" class="input_width"
											type="text"  
											onkeyup="checkotherCut(this)" />
									</td>
									<td class="inquire_item6">
									待修数量
									</td>
									<td class="inquire_form6">
										<input id="nweixiu_num" name="nweixiu_num" class="input_width"
											type="text"   readonly
											/>
												<input id="nweixiu_num1" name="nweixiu_num1" class="input_width"
											type="hidden" />
									</td>
								</tr>
								<tr>
									<td class="inquire_item6">
										<font color=red>*</font>在修数量
									</td>
									<td class="inquire_form6">
										<input id="zaixiucut_num" name="zaixiucut_num" class="input_width"
											type="text"  
											onkeyup="checkotherCut(this)" />
									</td>
									<td class="inquire_item6">
									在修数量
									</td>
									<td class="inquire_form6">
										<input id="nzaixiu_num" name="nzaixiu_num" class="input_width"
											type="text"   readonly
											/>
											<input id="nzaixiu_num1" name="nzaixiu_num1" class="input_width"
											type="hidden" />
									</td>
								</tr>
								<tr>
									<td class="inquire_item6">
										<font color=red>*</font>毁损数量
									</td>
									<td class="inquire_form6">
										<input id="huisuncut_num" name="huisuncut_num" class="input_width"
											type="text"  
											onkeyup="checkotherCut(this)" />
									</td>
									<td class="inquire_item6">
									毁损数量
									</td>
									<td class="inquire_form6">
										<input id="nhuisun_num" name="nhuisun_num" class="input_width"
											type="text"   readonly
											/>
												<input id="nhuisun_num1" name="nhuisun_num1" class="input_width"
											type="hidden" />
									</td>
								</tr>
							</table>
							</fieldset>
							<fieldset id="zhuanzi" style="display:none;">
							<legend>
								采集设备转资
							</legend>
							<table id="table2" width="100%" border="0" cellspacing="0"
								cellpadding="0" class="tab_line_height">
								<tr>
									<td class="inquire_item6">
										&nbsp;<font color=red>*</font>新增数量
									</td>
									<td class="inquire_form6">
										<input id="wanhaoadd_num" name="wanhaoadd_num" class="input_width"
											type="text"  
											onkeyup="checkWanhaoNumadd(this)" />
												<input id="wanhaoadd_num1" name="wanhaoadd_num1" class="input_width"
											type="hidden"  value="0"
										 />
									</td>
								</tr>
							</table>
							</fieldset>
						<fieldset id="xiugai">
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
											type="text"  
											onkeyup="checkWanhaoNum(this)" />
												<input id="wanhao_num1" name="wanhao_num1" class="input_width"
											type="hidden"  value="0"
										 />
									</td>
									<td class="inquire_item6">
										待修数量
									</td>
									<td class="inquire_form6">
										<input id="weixiu_num" name="weixiu_num" class="input_width"
											type="text" value="0" onkeyup="checkOtherNum(this)"/>
													<input id="weixiu_num1" name="weixiu_num1" class="input_width"
											type="hidden"  value="0"
										 />
									</td>
								</tr>
								<tr>
									<td class="inquire_item6">
										在修数量
									</td>
									<td class="inquire_form6">
										<input id="zaixiu_num" name="zaixiu_num" class="input_width"
											type="text" value="0" onkeyup="checkOtherNum(this)"/>
													<input id="zaixiu_num1" name="zaixiu_num1" class="input_width"
											type="hidden"  value="0"
										 />
									</td>
									<td class="inquire_item6">
										毁损数量
									</td>
									<td class="inquire_form6">
										<input id="huisun_num" name="huisun_num" class="input_width"
											type="text" value="0" onkeyup="checkOtherNum(this)"/>
													<input id="huisun_num1" name="huisun_num1" class="input_width"
											type="hidden"  value="0"
										 />
									</td>
								</tr>
								<tr>
								<td class="inquire_item6">
										盘亏数量
									</td>
									<td class="inquire_form6">
										<input id="pankui_num" name="pankui_num" class="input_width"
											type="text" value="0" onkeyup="checkOtherNum(this)"/>
													<input id="pankui_num1" name="pankui_num1" class="input_width"
											type="hidden"  value="0"
										 />
									</td>
									<td class="inquire_item6">
										待报废数量
									</td>
									<td class="inquire_form6">
										<input id="touseless_num" name="touseless_num" class="input_width"
											type="text" value="0" onkeyup="checkOtherNum(this)"/>
										<input id="tech_id" name="tech_id" type="hidden" value=""/>
											<input id="touseless_num1" name="touseless_num1" class="input_width"
											type="hidden"  value="0"
										 />
									</td>
								</tr>
								<tr>
								<td class="inquire_item6">
										未交回数量
									</td>
									<td class="inquire_form6">
										<input id="noreturn_num" name="noreturn_num" class="input_width"
											type="text" value="0" readonly/>
									</td>
								</tr>
							</table>
							</fieldset>
					<fieldset>
					<legend>
							现有存量
							</legend>
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
											type="text" readonly />
									<input id="oldunuse_num" name="oldunuse_num" class="input_width" type="hidden"/>
											
									</td>
								</tr>
								<tr>
									<td class="inquire_item6">
										在用数量
									</td>
									<td class="inquire_form6">
										<input id="use_num" name="use_num" class="input_width"
											type="text" value="0" readonly/>
															<input id="olduse_num" name="olduse_num" class="input_width" type="hidden"/>
									</td>
									<td class="inquire_item6">
										其他数量
									</td>
									<td class="inquire_form6">
										<input id="other_num" name="other_num" class="input_width"
											type="text" value="0" readonly/>
									<input id="oldother_num" name="oldother_num" class="input_width" type="hidden"/>
									</td>
								</tr>
								</table>
								<hr/>
									<table id="table2" width="100%" border="0" cellspacing="0"
								cellpadding="0" class="tab_line_height">
								<tr>
								<td class="inquire_item6">
										<font color=red>*</font>备注
									</td>
          <td class="inquire_form4" colspan="3" style="padding-left:2px;">
          	<textarea id="bak" name="bak" class="textarea" rows="1"  style="color:#B0B0B0;" ></textarea>
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
	//转出检验数量
	function checkotherCut(obj){
		var wanhaoValue = obj.value;
		var re = /^(?:(?:[1-9]\d*)|(?:0))$/;
		if(wanhaoValue==""){
			return;
		}
		if(!re.test(wanhaoValue)){
			alert("转出数量必须为数字!");
			obj.value = "";
        	return false;
		}else{
			//完好
			if(obj.id=='wanhaocut_num')
			{
				var flag=Number($("#nwanhao_num1").val())-Number($("#wanhaocut_num").val());
				if(flag<0)
				{
					alert("转出完好数量不能超过"+$("#nwanhao_num1").val());
					obj.value = "";
					$("#nwanhao_num").val($("#nwanhao_num1").val());
					return false;
				}
				var nwanhao_num = Number($("#nwanhao_num1").val())-Number($("#wanhaocut_num").val());
				$("#nwanhao_num").val(nwanhao_num);
			}
			//待报废数量
			if(obj.id=='touselesscut_num')
			{
				var flag=Number($("#ntouseless_num1").val())-Number($("#touselesscut_num").val());
				if(flag<0)
				{
					alert("转出待报废数量不能超过"+$("#ntouseless_num1").val());
					obj.value = "";
					$("#ntouseless_num").val($("#ntouseless_num1").val());
					return false;
				}
				var ntouseless_num = Number($("#ntouseless_num1").val())-Number($("#touselesscut_num").val());
				$("#ntouseless_num").val(ntouseless_num);
			}
			//待修数量
			if(obj.id=='weixiucut_num')
			{
				var flag=Number($("#nweixiu_num1").val())-Number($("#weixiucut_num").val());
				if(flag<0)
				{
					alert("转出待修数量不能超过"+$("#nweixiu_num1").val());
					obj.value = "";
					$("#nweixiu_num").val($("#nweixiu_num1").val());
					return false;
				}
				var nweixiu_num = Number($("#nweixiu_num1").val())-Number($("#weixiucut_num").val());
				$("#nweixiu_num").val(nweixiu_num);
			}
			//在修数量
			if(obj.id=='zaixiucut_num')
			{
				var flag=Number($("#nzaixiu_num1").val())-Number($("#zaixiucut_num").val());
				if(flag<0)
				{
					alert("转出在修数量不能超过"+$("#nzaixiu_num1").val());
					obj.value = "";
					$("#nzaixiu_num").val($("#nzaixiu_num1").val());
					return false;
				}
				var nzaixiu_num = Number($("#nzaixiu_num1").val())-Number($("#zaixiucut_num").val());
				$("#nzaixiu_num").val(nzaixiu_num);
			}
			//毁损数量
			if(obj.id=='huisuncut_num')
			{
				var flag=Number($("#nhuisun_num1").val())-Number($("#huisuncut_num").val());
				if(flag<0)
				{
					alert("转出毁损数量不能超过"+$("#nhuisun_num1").val());
					obj.value = "";
					$("#nhuisun_num").val($("#nhuisun_num1").val());
					return false;
				}
				var nhuisun_num = Number($("#nhuisun_num1").val())-Number($("#huisuncut_num").val());
				$("#nhuisun_num").val(nhuisun_num);
			}
			
			var other_num = Number($("#oldother_num").val())-Number($("#huisuncut_num").val())-Number($("#zaixiucut_num").val())-Number($("#weixiucut_num").val())-Number($("#touselesscut_num").val());
			$("#other_num").val(other_num);
			var unuse_num = Number($("#oldunuse_num").val())-Number($("#wanhaocut_num").val());
			$("#unuse_num").val(unuse_num);
			setTotalNum();
		}
	}
	function checkWanhaoNum(obj){
		var wanhaoValue = obj.value;
		var re = /^(?:(?:[1-9]\d*)|(?:0))$/;
		if(wanhaoValue==""){
			return;
		}
		if(!re.test(wanhaoValue)){
			alert("完好数量必须为数字!");
			obj.value = "";
        	return false;
		}else{
			setUnuseNum();
			setTotalNum();
			var flag=Number($("#oldtotal_num").val())-Number($("#total_num").val());
			if(flag<0)
			{
				alert("设备总数量不能大于"+$("#oldtotal_num").val()+",请重新分配!");
				obj.value = "";
				//设备数量初始化
				init();
	        	return false;
			}
		}
	}
	
	function checkWanhaoNumadd(obj){
		var wanhaoValue = obj.value;
		var re = /^(?:(?:[1-9]\d*)|(?:0))$/;
		if(wanhaoValue==""){
			return;
		}
		if(!re.test(wanhaoValue)){
			alert("转资数量必须为数字!");
			obj.value = "";
        	return false;
		}else{
			var wanhaoadd_num=Number($("#wanhaoadd_num").val());
			if(wanhaoadd_num==0)
				{
				alert("转资数量必须大于0!");
				obj.value = "";
	        	return false;
				}
			var unuse_num = Number($("#oldunuse_num").val())+Number($("#wanhaoadd_num").val());
			$("#unuse_num").val(unuse_num);
			setTotalNum();
		}
	}
	
	//操作类型
	function changeopertype()
	{
			//初始化设备数量
			init();
			var opertype=$("#opertype").val();
			//转出
			if(opertype=='2')
			{
				$("#zhuanchu").show();	
				$("#inorgname").show();
				$("#inorgcod").show();
				$("#zhuanzi").hide();	
				$("#xiugai").hide();
				$("#nwanhao_num").val($("#nwanhao_num1").val());
				$("#ntouseless_num").val($("#ntouseless_num1").val());
				$("#nweixiu_num").val($("#nweixiu_num1").val());
				$("#nzaixiu_num").val($("#nzaixiu_num1").val());
				$("#nhuisun_num").val($("#nhuisun_num1").val());
				$("#wanhaocut_num").val("");
				$("#touselesscut_num").val("");
				$("#weixiucut_num").val("");
				$("#zaixiucut_num").val("");
				$("#huisuncut_num").val("");
			}
			//转资
			if(opertype=='1')
			{
				$("#zhuanzi").show();	
				$("#zhuanchu").hide();
				$("#xiugai").hide();
				$("#inorgname").hide();
				$("#inorgcod").hide();
			}
			//修改
			if(opertype=='0')
			{
				$("#xiugai").show();
				$("#zhuanchu").hide();
				$("#zhuanzi").hide();
				$("#inorgname").hide();
				$("#inorgcod").hide();
			}
	}
	//设备数量初始化
	function init()
	{
		$("#total_num").val($("#oldtotal_num").val());
		$("#unuse_num").val($("#oldunuse_num").val());
		$("#use_num").val($("#olduse_num").val());
		$("#other_num").val($("#oldother_num").val());
	}
	//存储原来设备数量
	function savedeviceCount()
	{
		$("#oldtotal_num").val($("#total_num").val());
		$("#oldunuse_num").val($("#unuse_num").val());
		$("#olduse_num").val($("#use_num").val());
		$("#oldother_num").val($("#other_num").val());
	}
		
		function checkOtherNum(obj){
			var otherValue = obj.value;
			var re = /^(?:(?:[1-9]\d*)|(?:0))$/;
			if(otherValue==""){
				return;
			}
			if(!re.test(otherValue)){
				alert("其他数量必须为数字!");
				obj.value = "";
	        	return false;
			}else{
				setOtherNum();
				setTotalNum();
				var flag=Number($("#oldtotal_num").val())-Number($("#total_num").val());
				if(flag<0)
				{
					alert("设备总数量不能大于"+$("#oldtotal_num").val()+",请重新分配!");
					obj.value = "";
					//设备数量初始化
					init();
		        	return false;
				}
			}
		}
		function setOtherNum(){
			var other_num =Number($("#weixiu_num").val())+Number($("#zaixiu_num").val())+Number($("#touseless_num").val())+Number($("#pankui_num").val())+Number($("#huisun_num").val())+Number($("#noreturn_num").val());
			$("#other_num").val(other_num);
		}
		function setTotalNum(){
			var total_num = Number($("#use_num").val())+Number($("#other_num").val())+Number($("#unuse_num").val());
			$("#total_num").val(total_num);
		}
		function setUnuseNum(){
			var unuse_num = Number($("#wanhao_num").val());
			$("#unuse_num").val(unuse_num);
		}
		
		
		function setrecordNum(){
			if($("#wanhao_num1").val()==0)
			{
				$("#wanhao_num1").val($("#wanhao_num").val());
			}
			else
				{
			var wanhao_num1 = Number($("#wanhao_num").val())-Number($("#wanhao_num1").val());
			$("#wanhao_num1").val(wanhao_num1);
				}
			if($("#zaixiu_num1").val()==0)
				{
				$("#zaixiu_num1").val($("#zaixiu_num").val());
				}
			else
				{
			var zaixiu_num1 = Number($("#zaixiu_num").val())-Number($("#zaixiu_num1").val());
			$("#zaixiu_num1").val(zaixiu_num1);
				}
			if($("#weixiu_num1").val()==0)
			{
			$("#weixiu_num1").val($("#weixiu_num").val());
			}
			else
			{
			var weixiu_num1 =Number($("#weixiu_num").val())-Number($("#weixiu_num1").val());
			$("#weixiu_num1").val(weixiu_num1);
			}
			
			if($("#huisun_num1").val()==0)
			{
			$("#huisun_num1").val($("#huisun_num").val());
			}
			else
			{
			var huisun_num1 =Number($("#huisun_num").val())-Number($("#huisun_num1").val());
			$("#huisun_num1").val(huisun_num1);
			}
			
			if($("#pankui_num1").val()==0)
			{
			$("#pankui_num1").val($("#pankui_num").val());
			}
			else
			{
			var pankui_num1 =Number($("#pankui_num").val())-Number($("#pankui_num1").val());
			$("#pankui_num1").val(pankui_num1);
			}
			
			if($("#touseless_num1").val()==0)
			{
			$("#touseless_num1").val($("#touseless_num").val());
			}
		else
			{
			var touseless_num1 =Number($("#touseless_num").val())-Number($("#touseless_num1").val());
			$("#touseless_num1").val(touseless_num1);
			}
		}
	</script>
	<script type="text/javascript">	
		function pageInit(){
			var retObj;
			var unitSql = "select sd.coding_code_id,coding_name ";
			unitSql += "from comm_coding_sort_detail sd "; 
			unitSql += "where coding_sort_id ='5110000038' order by coding_code";
			var unitRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+unitSql+'&pageSize=10000');
			retObj = unitRet.datas;
			var optionhtml = "";
			for(var index=0;index<retObj.length;index++){
				optionhtml +=  "<option value='"+retObj[index].coding_code_id+"'>"+retObj[index].coding_name+"</option>";
			}
			$("#dev_unit_info").append(optionhtml);
			var querySql = "select gc1.dev_name as dev_type,";
			querySql += "ga.dev_acc_id,ga.dev_name,ga.dev_model,ga.dev_unit,ga.device_id,ga.usage_org_id,ga.usage_sub_id,ga.dev_position,det.coding_name as type_name,ga.type_id,";
			querySql += "tech.tech_id,nvl(tech.good_num,0) as wanhao_num,nvl(tech.torepair_num,0) as weixiu_num,";
			querySql += "nvl(tech.touseless_num,0) as touseless_num,nvl(tech.tocheck_num,0) as pankui_num,nvl(tech.destroy_num,0) as huisun_num, nvl(tech.noreturn_num,0) as noreturn_num,nvl(tech.repairing_num,0) as zaixiu_num, ";
			querySql += "usageorg.org_abbreviation as usage_org,unitsd.coding_name as unit_name,ga.ifcountry, owingorg.org_abbreviation as owning_org_name,ga.owning_org_id ";
			querySql += "from gms_device_coll_account ga ";
			querySql += "left join gms_device_coll_account_tech tech on ga.dev_acc_id=tech.dev_acc_id ";
			querySql += "left join gms_device_collectinfo gc1 on ga.device_id=gc1.device_id ";
			//querySql += "left join gms_device_collectinfo gc2 on gc1.node_parent_id=gc2.device_id ";
			querySql += "left join comm_coding_sort_detail det on det.coding_code_id=ga.type_id ";
			querySql += "left join comm_org_information usageorg on ga.usage_org_id=usageorg.org_id ";
			querySql += "left join comm_org_information owingorg on ga.owning_org_id=owingorg.org_id ";
			querySql += "left join comm_coding_sort_detail unitsd on ga.dev_unit=unitsd.coding_code_id ";
			querySql += "where ga.dev_acc_id = '<%=devaccid%>'";
			var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql);
			if(queryRet.datas && queryRet.datas.length > 0){
				var datas = queryRet.datas[0];
				for(var i in datas){
					$('#'+i).val(datas[i]);
					$('#'+i+'1').val(datas[i]);
					$('#n'+i).val(datas[i]);
					$('#n'+i+'1').val(datas[i]);
				}
				$("#ifcountry").val(datas.ifcountry);
				$("#oldtotal_num").val(datas.total_num);
				$("#dev_unit_info").val(datas.dev_unit);
				$("#usage_org_name").val(datas.usage_org);
			}
			$("#use_num").val(<%=unuse_num%>);
			$("#oldtotal_num").val(<%=total_num%>);
			
			var unuse_num = Number($("#wanhao_num").val());
			var other_num =Number($("#weixiu_num").val())+Number($("#touseless_num").val())+Number($("#pankui_num").val())+Number($("#huisun_num").val())+Number($("#noreturn_num").val())+Number($("#zaixiu_num").val());
			$("#unuse_num").val(unuse_num);
			$("#other_num").val(other_num);
			var total_num = Number($("#use_num").val())+Number($("#other_num").val())+Number($("#unuse_num").val());
			$("#total_num").val(total_num);
			savedeviceCount();
		}
		function showDevTreePage(){
			var obj = new Object();
			window.showModalDialog("<%=contextPath%>/rm/dm/collectTreeNew/collectTreeForSelect.jsp",obj,"dialogWidth:400px; dialogHeight:600px");
			if(obj.id!=undefined){
        		var device_id = obj.id.split("~")[0];
        		var sql = "select ci.*,sd.coding_name as type_name from gms_device_collectinfo ci "+
						"left join comm_coding_sort_detail sd on ci.node_type_id = sd.coding_code_id where ci.device_id='"+device_id+"'";
				var unitRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+sql);
				retObj = unitRet.datas;
			
				if(retObj!=null&&retObj.length>0){
					$('#dev_name').val(retObj[0].dev_name);
					$('#dev_model').val(retObj[0].dev_model);
					$('#device_id').val(retObj[0].device_id);
					$('#type_name').val(retObj[0].type_name);
					$('#type_id').val(retObj[0].node_type_id);
				}
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
		function setIntnum()
		{
			if($("#wanhao_num").val()=="")
			{
				$("#wanhao_num").val("0");
			}
			if($("#weixiu_num").val()=="")
			{
				$("#weixiu_num").val("0");
			}
			if($("#zaixiu_num").val()=="")
			{
				$("#zaixiu_num").val("0");
			}
			if($("#huisun_num").val()=="")
			{
				$("#huisun_num").val("0");
			}
			if($("#pankui_num").val()=="")
			{
				$("#pankui_num").val("0");
			}
			if($("#touseless_num").val()=="")
			{
				$("#touseless_num").val("0");
			}
			setOtherNum();
			setTotalNum();
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
			//if(document.getElementById("type_name").value==""){
			//	alert("请输入采集设备类型");
			//	return;
		//	}
			if(document.getElementById("usage_org_name").value==""){
				alert("请选择所在单位");
				return;
			}
		var bak=document.getElementById("bak").value;
			bak   =   bak.replace(/^\s+|\s+$/g,"");
			if(bak==""){
				alert("请填写备注信息");
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
			var opertype=$("#opertype").val();
			//修改
			if(opertype==0)
				{
				//文本框默认值为0
				setIntnum();
				var flag=Number($("#oldtotal_num").val())-Number($("#total_num").val());
				if(flag<0)
					{
						alert("总数量不能增加,请重新分配");
						return false;
					}
				if(flag>0)
				{
					alert("总数量不能减少,请重新分配");
					return false;
				}
				}
			//转资
			if(opertype==1)
				{
				var wanhaoadd_num=$("#wanhaoadd_num").val();
				if(wanhaoadd_num=="")
				{
					alert("转资数量不能为空!");
					return false;
				}
				}
			//转出
			if(opertype==2)
				{
					var info=$("#checkOrg").val();
					if(info=="")
						{
							alert("请选择转入单位!");
							return false;
						}
				var wanhaocut_num=$("#wanhaocut_num").val();
				var touselesscut_num=$("#touselesscut_num").val();
				var weixiucut_num=$("#weixiucut_num").val();
				var zaixiucut_num=$("#zaixiucut_num").val();
				var huisuncut_num=$("#huisuncut_num").val();
				if(wanhaocut_num=="")
				{
						$("#wanhaocut_num").val("0");
				}
				if(touselesscut_num=="")
				{
					$("#touselesscut_num").val("0");
				}
				if(weixiucut_num=="")
				{
					$("#weixiucut_num").val("0");
				}
				if(zaixiucut_num=="")
				{
					$("#zaixiucut_num").val("0");
				}if(huisuncut_num=="")
				{
					$("#huisuncut_num").val("0");
				}
				var wanhaocut_num=$("#wanhaocut_num").val();
				var touselesscut_num=$("#touselesscut_num").val();
				var weixiucut_num=$("#weixiucut_num").val();
				var zaixiucut_num=$("#zaixiucut_num").val();
				var huisuncut_num=$("#huisuncut_num").val();
				var flag=Number($("#wanhaocut_num").val())+Number($("#touselesscut_num").val())+Number($("#weixiucut_num").val())+Number($("#zaixiucut_num").val())+Number($("#huisuncut_num").val());
					if(flag<=0)
					{
						alert("转出数量必须大于0!");
						return false;
					}
			}
			
			if(confirm('确定要提交吗?')){
				setrecordNum();
				cruConfig.contextPath = '<%=contextPath%>';
				$("#dev_unit").val($("#dev_unit_info").val());
				var params = $("#form1").serialize();
				var retObj = jcdpCallService("DevProSrv","updateCollectDevAccount",params);
				if(retObj.returnCode != 0){
					alert("您选择的所在单位已存在此采集设备台账信息,修改失败!");
				}else{
					parent.list.frames[1].location.reload();
					newClose();
				}
			}
		}
</script>
	</body>
</html>


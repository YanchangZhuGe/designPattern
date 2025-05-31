<%@page contentType="text/html;charset=UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="java.util.Date"%>
<%@taglib prefix="auth" uri="auth"%>
<%@taglib uri="wf" prefix="wf"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String appDate = new java.text.SimpleDateFormat("yyyy-MM-dd").format(new Date());
	String flag = request.getParameter("flag");
	if (null == flag) {
		flag = "add";
	}
	String ck_id = request.getParameter("ck_id");
	if (null == ck_id) {
		ck_id = "";
	}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<%@include file="/common/include/quotesresource.jsp"%>
	<title>添加验证通知</title>
</head>
<body class="bgColor_f3f3f3" >
	<form name="form1" id="form1" method="post" action="" enctype="multipart/form-data">
		<div id="new_table_box" >
			<div id="tab" class="easyui-tabs" data-options="fit:true,plain:true" style="width:98%">
				<div title="基本信息">
					<fieldset style="margin:2px;padding:2px;">
						<legend>基本信息</legend>
						<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
							<tr>
								<td class="inquire_item4"><font color=red>*</font>&nbsp;验收单号:</td>
								<td class="inquire_form4">
									<input name="ck_cid" id="ck_cid" class="input_width easyui-validatebox main" type="text" value="" readonly="readonly" />
								</td>
								<td class="inquire_item4"><font color=red>*</font>&nbsp;需求计划单号</td>
								<td class="inquire_form4">
									<input name="apply_num" id="apply_num" class="input_width main" type="text" value="" readonly />
									<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16"
										style="cursor:hand;" onclick="showDevAccountPage()" />
								</td>
							</tr>
							<tr>
								<td class="inquire_item4"><font color=red>*</font>&nbsp;合同号:</td>
								<td class="inquire_form4">
									<input name="pact_num" id="pact_num" class="input_width easyui-validatebox main" type="text" value=""
										data-options="validType:'length[0,50]'" maxlength="50" required />
								</td>
							</tr>
							<tr>
								<td class="inquire_item4"><font color=red>*</font>&nbsp;供货商:</td>
								<td class="inquire_form4">
									<input name="ck_company" id="ck_company" class="input_width easyui-validatebox main" type="text" value=""
										data-options="validType:'length[0,50]'" maxlength="50" required />
								</td>
								<td class="inquire_item4"><font color=red>*</font>&nbsp;供货商满意度:</td>
								<td class="inquire_form4">
									<select name="ck_company_score" id="ck_company_score" class="input_width main" required>
										<option value="1">非常满意</option>
										<option value="2">满意</option>
										<option value="3">一般</option>
										<option value="4">不满意</option>
										<option value="5">非常不满意</option>
									</select>
								</td>
							</tr>
						</table>
					</fieldset>
					<fieldset style="margin:2px;padding:2px;">
						<legend>设备信息</legend>
						<table style="table-layout:fixed;text-align:center;" width="100%" border="0" cellspacing="0"
							cellpadding="0" class="tab_info" id="itemTable">
							<tr>
								<td width="10%" class="ali_btn" style="position: center;">
									<span class="zj"><a href="javascript:void(0);" onclick="insertTr()" title="添加"></a></span>
								</td>
								<td width="10%">序号</td>
								<td width="20%">设备名称</td>
								<td width="20%">型号</td>
								<td width="10%">数量</td>
								<td width="20%">生产厂家</td>
								<td width="10%">计量单位</td>
							</tr>
						</table>
					</fieldset>
					<fieldset style="margin:2px;padding:2px;">
						<legend>验收小组</legend>
						<table style="table-layout:fixed;text-align:center;" width="100%" border="0" cellspacing="0"
							cellpadding="0" class="tab_info" id="itemTable2">
							<tr>
								<td width="10%" class="ali_btn">
									<span class="zj"><a href="javascript:void(0);" onclick="insertTr2()" title="添加"></a></span>
								</td>
								<td width="10%">序号</td>
								<td width="20%">姓名</td>
								<td width="20%">所在单位</td>
								<td width="20%">性别</td>
								<td width="20%">职称</td>
							</tr>
						</table>
					</fieldset>
				</div>
				<div title="验收信息">
					<fieldset style="margin: 2px; padding: 2px">
						<legend>验收信息</legend>
						<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
							<tr>
								<td class="inquire_item4">&nbsp;验收单位:</td>
								<td class="inquire_form4">
									<input name="ck_sectors" id="ck_sectors" class="input_width main" type="text" value="" size="50" readonly /> 
									<input name="ck_sector" id="ck_sector" value="" type="hidden" class="main" /> 
									<img id="show-btn" src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor: pimter;" onclick="showOrgTreePage1()" />
								</td>
								<td class="inquire_item4">&nbsp;验收单位负责人:</td>
								<td class="inquire_form4">
									<input name="ck_pyperson" id="ck_pyperson" maxlength="50" class="input_width easyui-validatebox main" type="text" value="" data-options="validType:'length[0,50]'" required />
								</td>
							</tr>
							<tr>
								<td class="inquire_item4">&nbsp;验收结果:</td>
								<td class="inquire_form4">
									<select id="ck_outcome" name="ck_outcome" class="input_width main">
										<option value="合格">合格</option>
										<option value="不合格">不合格</option>
									</select>
								</td>
								<td class="inquire_item4">&nbsp;验收结论:</td>
								<td class="inquire_form4">
									<input name="ck_conclusion" id="ck_conclusion" maxlength="50" class="input_width easyui-validatebox main" type="textarea" data-options="validType:'length[0,50]'" value="" required />
								</td>
							</tr>
							<tr>
								<td class="inquire_item4" >&nbsp;验收时间:</td>
								<td class="inquire_form4">
									<input type="text" name="ck_date" id="ck_date" value="<%=appDate %>" class="input_width easyui-datebox main" style="width:200px" editable="false" required/>
								</td>
								<td class="inquire_item4" >&nbsp;实际到货时间:</td>
								<td class="inquire_form4">
									<input type="text" name="sar_date" id="sar_date" value="<%=appDate %>" class="input_width easyui-datebox main" style="width:200px" editable="false" required/>
								</td>
							</tr>
						</table>
					</fieldset>
					<fieldset style="margin:2px;padding:2px">
						<legend>开箱前检查</legend>
						<table border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
							<tr>
								<td class="inquire_form4">
									<input type="checkbox" name="num_right" id="num_right" checked="checked"/>件数相符
								</td>
								<td class="inquire_form4">
									<input type="checkbox" name="name_right" id="name_right" checked="checked"/>名称相符
								</td>
								<td class="inquire_form4">
									<input type="checkbox" name="pg_right" id="pg_right" checked="checked"/>外包装相符
								</td>
								<td class="inquire_form4">
									<input type="checkbox" name="pg_corrode" id="pg_corrode" checked="checked"/>外观无缺损腐蚀
								</td>
							</tr>
						</table>
					</fieldset>
					<fieldset style="margin:2px;padding:2px">
						<legend>开箱检查</legend>
						<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
							<tr>
								<td class="inquire_form4">
									<input type="checkbox" name="thing_right" id="thing_right" checked="checked"/>实物与装箱单相符
								</td>
								<td class="inquire_form4">
									<input type="checkbox" name="kname_right" id="kname_right" checked="checked"/>开箱后名称相符
								</td>
								<td class="inquire_form4">
									<input type="checkbox" name="injure_right" id="injure_right" checked="checked"/>无受损
								</td>
							</tr>
						</table>
					</fieldset>
					<fieldset style="margin:2px;padding:2px">
						<legend>性能指标测试</legend>
						<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
							<tr>
								<td class="inquire_form4">
									<input type="checkbox" name="function_right" id="function_right" checked="checked"/>设备性能指标是否合适
								</td>
							</tr>
						</table>
					</fieldset>
					<fieldset style="margin:2px;padding:2px">
						<legend>验证</legend>
						<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
							<tr>
								<td class="inquire_form4">
									<input type="checkbox" name="card_right" id="card_right" checked="checked"/>证件合格
								</td>
								<td class="inquire_form4">
									<input type="checkbox" name="data_right" id="data_right" checked="checked"/>资料齐全
								</td>
							</tr>
						</table>
						<table width="100%" border="1" cellspacing="0" cellpadding="0" class="tab_line_height">
						    <tr>
						        <td class="inquire_item4">&nbsp;设备交付验收单:</td>
						        <auth:ListButton functionId="" css="dr" event="onclick='excelDataAddSkill(1)'"></auth:ListButton>
						    </tr>
						    <tr>
						        <td colspan="3">
						            <table style="width:97.9%" border="0" cellspacing="0" cellpadding="0" id="ck_list">
						                <input name="ck_list_" id="ck_list_" type="hidden" />
						            </table>
						        </td>
						    </tr>
						    <tr>
						        <td class="inquire_item4">&nbsp;新购设备验收报告:</td>
						        <auth:ListButton functionId="" css="dr" event="onclick='excelDataAddTest(1)'"></auth:ListButton>
						    </tr>
						    <tr>
						        <td colspan="3">
						            <table style="width:97.9%" border="0" cellspacing="0" cellpadding="0" id="nck_list">
						                <input name="nck_list_" id="nck_list_" type="hidden" />
						            </table>
						        </td>
						    </tr>
						    <tr>
						        <td class="inquire_item4">&nbsp;设备验收信息表:</td>
						        <auth:ListButton functionId="" css="dr" event="onclick='excelDataAddUser(1)'"></auth:ListButton>
						    </tr>
						    <tr>
						        <td colspan="3">
						            <table style="width:97.9%" border="0" cellspacing="0" cellpadding="0" id="ck_posts">
						                <input name="ck_posts_" id="ck_posts_" type="hidden" />
						            </table>
						        </td>
						    </tr>
						    <tr>
						        <td class="inquire_item4">&nbsp;存档资料:</td>
						        <auth:ListButton functionId="" css="dr" event="onclick='excelDataAdd(1)'"></auth:ListButton>
						    </tr>
						    <tr>
						        <td colspan="3">
						            <table style="width:97.9%" border="0" cellspacing="0" cellpadding="0" id="ck_post_many">
						                <input name="ck_post_many_" id="ck_post_many_" type="hidden" />
						            </table>
						        </td>
						    </tr>
						</table>
					</fieldset>
					<fieldset style="margin:2px;padding:2px">
						<legend>问题信息</legend>
						<table style="table-layout: fixed; text-align: center;" width="100%" border="0" 
							cellspacing="0" cellpadding="0" class="tab_info" id="itemTable3">
							<tr>
								<td width="10%" class="ali_btn" style="position: center;">
									<span class="zj"><a href="javascript:void(0);" onclick="insertTr3()" title="添加"></a></span>
								</td>
								<td width="10%">序号</td>
								<td width="50%">问题描述</td>
								<td width="30%">预计解决时间</td>
							</tr>
						</table>
					</fieldset>
				</div>
			</div>
			<div id="oper_div">
				<span class="tj_btn"><a href="####" id="submitButton" onclick="submitInfo()"></a></span>
				<span class="gb_btn"><a href="####" onclick="newClose()"></a></span>
			</div>
		</div>
	</form>
</body>
<script type="text/javascript">

	cruConfig.contextPath = "<%=contextPath%>";
	cruConfig.cdtType = 'form';
	var flag = "<%=flag%>";
	var ck_id = "<%=ck_id%>";
	
	// 获取当前时间
	function getNowFormatTime() {
        var date = new Date();
        var year = date.getFullYear();
        var month = date.getMonth() + 1;
        var strDate = date.getDate();
        var hours = date.getHours(); 
        var min = date.getMinutes();  
        var sec = date.getSeconds();  
        if (month >= 1 && month <= 9) {
            month = "0" + month;
        }
        if (strDate >= 0 && strDate <= 9) {
            strDate = "0" + strDate;
        }
        if (hours >= 1 && hours <= 9) {
            hours = "0" + hours;
        }
        if (min >= 0 && min <= 9) {
            min = "0" + min;
        }
        if (sec >= 0 && sec <= 9) {
            sec = "0" + sec;
        }
        var currentdate = year + month + strDate + hours + min + sec;
        return currentdate;
    }
	
	// 得到当前日期
	function getNowFormatDate() {
	    var date = new Date();
	    var seperator1 = "-";
	    var year = date.getFullYear();
	    var month = date.getMonth()+1;
	    var strDate = date.getDate();
	    if (month >= 1 && month <= 9) {
	        month = "0" + month;
	    }
	    if (strDate >= 0 && strDate <= 9) {
	        strDate = "0" + strDate;
	    }
	    var currentdate = year + seperator1 + month + seperator1 + strDate
	    return currentdate;
	}
	
	//选择机构树
	function showOrgTreePage1(){
		var returnValue=window.showModalDialog("<%=contextPath%>/rm/dm/deviceAccount/selectOrgHR2.jsp?codingSortId=0110000001","test","");
		var strs= new Array(); //定义一数组
		if(!returnValue){
			return;
		}
		strs = returnValue.split("~"); //字符分割
		var names = strs[0].split(":");
		var id = strs[1].split(":");
		var outorgname = $("#ck_sector").val();
		document.getElementById("ck_sectors").value = names[1];
		document.getElementById("ck_sector").value = id[1];
	}
	
	//页面初始化调用方法
	$(function(){
		// 加载基本信息
		loadBasicData();
		// 加载验收信息
	    loadCheckData();
	});
	
	// 加载基本信息
	function loadBasicData() {
		if ("add" == flag) {
            var x = getNowFormatTime()
            $("#ck_cid").val(x);
        }
        if ("update" == flag) {
            var retObj = jcdpCallService("CheckDevReady", "getCheckItemInfo", "ck_id=" + ck_id);
            if (typeof retObj.data != "undefined") {
                var data = retObj.data;
                $(".main").each(function () {
                    var temp = this.id;
                    $("#" + temp).val(data[temp] != undefined ? data[temp] : "");
                });
            }
            if (typeof retObj.datas != "undefined") {
                var datas = retObj.datas;
                for (var i = 0; i < datas.length; i++) {
                    var ts = insertTr("old");
                    var data = datas[i];
                    $.each(data, function (k, v) {
                        if (null != v && "" != v) {
                            $("#itemTable #" + k + "_" + ts).val(v);
                        }
                    });
                }
                order = datas.length;
            }
            if (typeof retObj.datass != "undefined") {
                var datass = retObj.datass;
                for (var i = 0; i < datass.length; i++) {
                    var ts = insertTr2("old");
                    var data = datass[i];
                    $.each(data, function (k, v) {
                        if (null != v && "" != v) {
                            $("#itemTable2 #" + k + "_" + ts).val(v);
                        }
                    });
                }
                orders = datass.length;
            }
        }
	}
	
	// 加载验收信息
    function loadCheckData() {
        var retObj;
        var baseDate;
        baseData = jcdpCallService("CheckDevDo", "getCheckDofInfo", "ck_id=<%=ck_id%>");
        if (typeof baseData.fdataPublic != "undefined") {
            // 有附件显示附件
            for (var tr_id = 1; tr_id <= baseData.fdataPublic.length; tr_id++) {
                if (baseData.fdataPublic[tr_id - 1].file_type == "ck_list") {
                    insertFilePublicSkill(baseData.fdataPublic[tr_id - 1].file_name, baseData.fdataPublic[tr_id - 1].file_id);
                    flag_public = 1;
                }
                if (baseData.fdataPublic[tr_id - 1].file_type == "nck_list") {
                    insertFilePublicTest(baseData.fdataPublic[tr_id - 1].file_name, baseData.fdataPublic[tr_id - 1].file_id);
                    flag_public = 1;
                }
                if (baseData.fdataPublic[tr_id - 1].file_type == "ck_posts") {
                    insertFilePublicUser(baseData.fdataPublic[tr_id - 1].file_name, baseData.fdataPublic[tr_id - 1].file_id);
                    flag_public = 1;
                }
                if (baseData.fdataPublic[tr_id - 1].file_type == "ck_post_many") {
                    insertFilePublic(baseData.fdataPublic[tr_id - 1].file_name, baseData.fdataPublic[tr_id - 1].file_id);
                    flag_public = 1;
                }
            }
        }
        if ("update" == flag) {
            //隐藏选择日期按钮
            $("#cal_button").hide();
            retObj = jcdpCallService("CheckDevDo", "getCheckDofInfo", "ck_id=<%=ck_id%>");
            if (typeof retObj.data != "undefined") {
                var _ddata = retObj.data;
                $(".main").each(function () {
                    var temp = this.id;
                    $("#" + temp).val(_ddata[temp] != undefined ? _ddata[temp] : "");
                });
            }
            $("#ck_date").datebox("setValue", retObj.data.ck_date);
            $("#sar_date").datebox("setValue", retObj.data.sar_date);
            // 
            if (retObj.data.num_right != "1") {
                document.all.num_right.checked = false;
            }
            //
            if (retObj.data.pg_right != "1") {
                document.all.pg_right.checked = false;
            }
            //
            if (retObj.data.pg_corrode != "1") {
                document.all.pg_corrode.checked = false;
            }
            //
            if (retObj.data.name_right != "1") {
                document.all.name_right.checked = false;
            }
            //
            if (retObj.data.thing_right != "1") {
                document.all.thing_right.checked = false;
            }
            //
            if (retObj.data.kname_right != "1") {
                document.all.kname_right.checked = false;
            }
            //
            if (retObj.data.injure_right != "1") {
                document.all.injure_right.checked = false;
            }
            //
            if (retObj.data.function_right != "1") {
                document.all.function_right.checked = false;
            }
            //
            if (retObj.data.card_right != "1") {
                document.all.card_right.checked = false;
            }
            //
            if (retObj.data.data_right != "1") {
                document.all.data_right.checked = false;
            }
        }
        if (typeof retObj.datas != "undefined") {
            var o = 1;
            var datas = retObj.datas;
            for (var i = 0; i < datas.length; i++) {
                var ts = insertTr3("old");
                var data = datas[i];
                $.each(data, function (k, v) {
                    if (null != v && "" != v) {
                        $("#itemTable3 #" + k + "_" + ts).val(v);
                    }
                    $("#y_date_" + o).datebox("setValue", data.y_date);
                    $("#question_id_" + o).val(data.question_id);
                });
                o++;
            }
        }
    }
	
	//选择调配单位机构树
	function showOrgTreePage(orders){
		var returnValue = window.showModalDialog("<%=contextPath%>/rm/dm/deviceAccount/selectOrgHR2.jsp?codingSortId=0110000001", "test", "");
		var strs = new Array(); //定义一数组
		if (!returnValue) {
			return;
		}
		strs = returnValue.split("~"); //字符分割
		var names = strs[0].split(":");
		var id = strs[1].split(":");
		var outorgname = $("#ps_sector_" + orders).val();
		document.getElementById("ps_sectors_" + orders).value = names[1];
		document.getElementById("ps_sector_" + orders).value = id[1];
	}

	//提交保存
	function submitInfo() {
		if (validateBasicData() && validateCheckData()){
			$.messager.confirm("操作提示", "您确定要执行操作吗？", function (data) {
	            if (data) {
	            	$.messager.progress({title:'请稍后',msg:'数据保存中....'});
	    			$("#submitButton").attr({"disabled":"disabled"});
	    			document.getElementById("form1").action = "<%=contextPath%>/dmsManager/check/saveOrUpdateCheckReadyInfo.srq?flag="+flag+"&ck_id="+ck_id;
	    			document.getElementById("form1").submit();
	            }
	        });
		}
	}
	// 校验基本信息
	function validateBasicData() {
		//保留的行信息
		var ck_cid = $.trim($("#ck_cid").val());
		var apply_num = $.trim($("#apply_num").val());
		var pact_num = $.trim($("#pact_num").val());
		var ck_company = $.trim($("#ck_company").val());
		if (ck_cid.length <= 0) {
			$.messager.alert("提示", "验收单号不能为空!");
			return false;
		}
		if (apply_num.length <= 0) {
			$.messager.alert("提示", "需求计划单号不能为空!");
			return false;
		}
		if (pact_num.length <= 0) {
			$.messager.alert("提示", "合同号不能为空!");
			return false;
		}
		return true;
	}
	// 校验验收信息
	function validateCheckData() {
		//保留的行信息
		var count = 0;
		var ck_id = $.trim($("#ck_id").val());
		var ck_date = $("#ck_date").datebox('getValue');
		var sar_date = $("#sar_date").datebox('getValue');
		var ck_conclusion = $.trim($("#ck_conclusion").val());
		var ck_outcome = document.getElementsByName("ck_outcome")[0].value;
		var ck_sectors = $.trim($("#ck_sectors").val());
		var ck_pyperson = $.trim($("#ck_pyperson").val());
		var myDate = getNowFormatDate();

		if (ck_sectors.length <= 0) {
			$.messager.alert("提示", "请填写验收单位!", "warning");
			return false;
		}
		if (ck_pyperson.length <= 0) {
			$.messager.alert("提示", "请填写验收单位负责人!", "warning");
			return false;
		}
		if (ck_conclusion.length <= 0) {
			$.messager.alert("提示", "请填写验收结论!", "warning");
			return false;
		}
		if (ck_outcome.length <= 0) {
			$.messager.alert("提示", "请填写验收结果!", "warning");
			return false;
		}

		if (CompareDate(myDate, ck_date) == false) {
			$.messager.alert("提示", "验收时间不能大于当前时间!", "warning");
			return false;
		}

		if (CompareDate(myDate, sar_date) == false) {
			$.messager.alert("提示", "实际到货时间不能大于当前时间!", "warning");
			return false;
		}
		if (CompareDate(sar_date, ck_date) == true && ck_date != sar_date) {
			$.messager.alert("提示", "实际到货时间不能大于验收时间!", "warning");
			return false;
		}
		return true;
	}
	
	//对比时间
	function CompareDate(d1,d2){
		return ((new Date(d1.replace(/-/g,"/"))) >= (new Date(d2.replace(/-/g,"/"))));
	}
	
	//日期判断
	function disInput(index){
		//重新渲染加入的日期框
		$.parser.parse($("#tr"+index));
		//第一次进入移除验证
		$('.validatebox-text').removeClass('validatebox-invalid');
	}
	
	//获取需求单号
	function showDevAccountPage(){
		var obj = new Object();
		var dialogurl = "<%=contextPath%>/dmsManager/check/need_num.jsp";
		dialogurl = encodeURI(dialogurl);
		var vReturnValue = window.showModalDialog(dialogurl , obj ,"dialogWidth=950px;dialogHeight=350px");
		if(vReturnValue!=undefined){
			var content= vReturnValue.split('~');
			document.getElementById("apply_num").value=content[0];
		}
	}
	
	//指标项序号
	var order = 0;
	var orders = 0;
	// 设备信息新增
	function insertTr(old){
		order++;
		var temp = "";
		if(old=="old"){
			temp +="<tr id='tr_"+order+"' class='old' tempindex='"+order+"'>";
		}else{
			temp +="<tr id='tr_"+order+"' class='new' tempindex='"+order+"'>";
		}
		temp =temp + ("<td><input name='dev_id_"+order+"' id='dev_id_"+order+"' value='000' type='hidden'/><img src='<%=contextPath%>/images/delete.png' width='16' height='16' style='cursor:hand;' onclick='deleteTr(this)'/></td>" +
		"<td>"+order+"</td> "+
		"<td><input name='dev_name_"+order+"' id='dev_name_"+order+"' type='text' style='height:20px;width:90%;' class='easyui-validatebox' data-options=\"validType:'length[0,50]'\" maxlength='50' /></td>"+
		"<td><input name='dev_model_"+order+"' id='dev_model_"+order+"' type='text' style='height:20px;width:90%;' class='easyui-validatebox' data-options=\"validType:'length[0,50]'\" maxlength='50'/></td>"+
		"<td><input name='dev_num_"+order+"' id='dev_num_"+order+"' type='text' style='height:20px;width:90%;' class='easyui-numberbox' precision='0' max='999999' size='6' maxlength='6' /></td>"+
		"<td><input name='dev_producer_"+order+"' id='dev_producer_"+order+"' type='text' style='height:20px;width:90%;' class='easyui-validatebox' data-options=\"validType:'length[0,50]'\" maxlength='50'/></td>"+
		"<td><input name='dev_type_"+order+"' id='dev_type_"+order+"' type='text' style='height:20px;width:90%;' class='easyui-validatebox' data-options=\"validType:'length[0,50]'\" maxlength='50'/></td>"+
		"</tr>");
		 var targetObj = $(temp);
	     $.parser.parse(targetObj);
		$("#itemTable").append(targetObj);
		return order; 
	}
	// 验收小组新增
	function insertTr2(old){
		orders++;
		var temp = "";
		if(old=="old"){
			temp +="<tr id='tr_"+orders+"' class='old' tempindex='"+orders+"'>";
		}else{
			temp +="<tr id='tr_"+orders+"' class='new' tempindex='"+orders+"'>";
		}
		temp =temp + ("<td><input name='ps_id_"+orders+"' id='ps_id_"+orders+"' value='000' type='hidden'/><input name='item_order_"+orders+"' id='item_order_"+orders+"' value='"+orders+"' type='hidden'/>"+
				"<img src='<%=contextPath%>/images/delete.png' width='16' height='16' style='cursor:hand;' onclick='deleteTr2(this)'/></td>" +
		"<td>"+orders+"</td> "+
		"<td><input name='ps_name_"+orders+"' id='ps_name_"+orders+"' type='text' style='height:20px;width:90%;' maxlength='50'/></td>"+
		"<td><input name='ps_sectors_"+orders+"' value='<%=user.getOrgName() %>' id='ps_sectors_"+orders+"' type='text' style='height:20px;width:80%;' readonly/>"+
			"<img id='show-btn' src='<%=contextPath%>/images/magnifier.gif' width='16' height='16' style='cursor:pimter;' onclick='showOrgTreePage("+orders+")'></td>"+
		"<td><select name='ps_sex_"+orders+"' id='ps_sex_"+orders+"' style='height:20px;width:90%;'>"+
		"<option value ='男'>男</option>"+
		"<option value ='女'>女</option></td>"+
  		"<td><input name='ps_job_"+orders+"' id='ps_job_"+orders+"' type='text' style='height:20px;width:90%;' maxlength='50'/></td>"+
  		"<input name='ps_sector_"+orders+"' id='ps_sector_"+orders+"' value='<%=user.getOrgId() %>' type='hidden'/>"+
		"</tr>");
		 var targetObj = $(temp);
	     $.parser.parse(targetObj);
		$("#itemTable2").append(targetObj);
		return orders; 
	}
	
    // 问题信息新增
	var order3 = 0;
    function insertTr3(old) {
        order3++;
        var timestamp = new Date().getTime();//获取时间戳
        var temp = "";
        if (old == "old") {
            temp += "<tr id='tr_" + order3 + "' class='old' tempindex='" + order3 + "'>";
        } else {
            temp += "<tr id='tr_" + order3 + "' class='new' tempindex='" + order3 + "'>";
        }
        temp = temp + ("<td><input name='question_id_" + order3 + "' id='question_id_" + order3 + "' value='000' type='hidden'/>" +
            "<img src='<%=contextPath%>/images/delete.png' width='16' height='16' style='cursor:hand;' onclick='deleteTr3(this)'/></td>" +
            "<td>" + order3 + "</td> " +
            "<td><input name='question_instruction_" + order3 + "' maxlength='50' id='question_instruction_" + timestamp + "' type='text' style='height:20px;width:90%;' class='easyui-validatebox' data-options=\"validType:'length[0,50]'\" /></td>" +
            "<td><input type='text' name='y_date_" + order3 + "' id='y_date_" + order3 + "' value='<%=appDate%>' class='input_width easyui-datebox' style='height:20px;width:98%;' editable='false' required/></td>" +
            "</tr>");
        var targetObj = $(temp);
        $.parser.parse(targetObj);
        $("#itemTable3").append(targetObj);
        return timestamp;
    }
	
	// 设备信息删除
	function deleteTr(item){
		//页面修改时要处理的操作
		if($(item).parent().parent().attr("class")=="old"){
			var itemId = $(item).parent().children("input").first().val();
			var tts=new Date().getTime();
			$("#form").append("<input type='hidden' name='del_tr_dev_"+tts+"' value='"+itemId+"'/>");
		}
		//获取行id
		var temp = $(item).parent().parent().attr("id");
		//删除行
		// $(item).parent().parent().remove();
		//序号重新排序
		var _index = parseInt(temp.split("_")[1]);
		for(var j=_index;j<order;j++){
			//给隐藏域序号赋值
			$("#tr_"+(j+1)).children().eq(0).children().eq(1).val(j);
			//给序号赋值
			var order_td = $("#tr_"+(j+1)).children().eq(1);
			order_td.html(j);
			//给tr 属性 赋值
			$("#tr_"+(j+1)).attr("id","tr_"+j);
		}
		if(_index = order){
			 if(confirm('确定要删除吗?')){  
				var retObj = jcdpCallService("CheckPersonDev", "deleteCheckDevInfo", "dev_id="+itemId);				
				if(typeof retObj.operationFlag!="undefined"){
					var dOperationFlag=retObj.operationFlag;
					if(''!=dOperationFlag){
						if("failed"==dOperationFlag){
							alert("删除失败！");
						}	
						if("success"==dOperationFlag){
							alert("删除成功！");
							//删除行
							$(item).parent().parent().remove();
							//索引减一
							order=order-1;
							queryData(cruConfig.currentPage);
						}
					}
				}
			} 
		}
		
	}
	
	// 验收小组删除
	function deleteTr2(item2) {
		//页面修改时要处理的操作
		if ($(item2).parent().parent().attr("class") == "old") {
			var itemId2 = $(item2).parent().children("input").first().val();
			var tts = new Date().getTime();
			$("#form").append("<input type='hidden' name='del_tr_ps_"+tts+"' value='"+itemId2+"'/>");
		}
		//获取行id
		var temps = $(item2).parent().parent().attr("id");
		//序号重新排序
		var _index = parseInt(temps.split("_")[1]);
		for (var j = _index; j < orders; j++) {
			//给隐藏域序号赋值
			$("#tr_" + (j + 1)).children().eq(0).children().eq(1).val(j);
			//给序号赋值
			var order_td = $("#tr_" + (j + 1)).children().eq(1);
			order_td.html(j);
			//给tr 属性 赋值
			$("#tr_" + (j + 1)).attr("id", "tr_" + j);
		}
		if (_index = orders) {
			if (confirm('确定要删除吗?')) {
				var retObj = jcdpCallService("CheckPersonDev", "deleteCheckPersonInfo", "ps_id=" + itemId2);
				if (typeof retObj.operationFlag != "undefined") {
					var dOperationFlag = retObj.operationFlag;
					if ('' != dOperationFlag) {
						if ("failed" == dOperationFlag) {
							alert("删除失败！");
						}
						if ("success" == dOperationFlag) {
							alert("删除成功！");
							//删除行
							$(item2).parent().parent().remove();
							//索引减一
							orders = orders - 1;
							queryData(cruConfig.currentPage);
						}
					}
				}
			}
		}
	}
	
	// 问题信息删除
    function deleteTr3(item) {
        //页面修改时要处理的操作
        if ($(item).parent().parent().attr("class") == "old") {
            var itemId = $(item).parent().children("input").first().val();
            var tts = new Date().getTime();
            $("#form1").append("<input type='hidden' name='del_tr_" + tts + "' value='" + itemId + "'/>");
        }
        //获取行id
        var temp = $(item).parent().parent().attr("id");
        //删除行
        $(item).parent().parent().remove();
        //序号重新排序
        var _index = parseInt(temp.split("_")[1]);
        for (var j = _index; j < order3; j++) {
            //给隐藏域序号赋值
            $("#tr_" + (j + 1)).children().eq(0).children().eq(1).val(j);
            //给序号赋值
            var order3_td = $("#tr_" + (j + 1)).children().eq(1);
            order3_td.html(j);
            //给tr 属性 赋值
            $("#tr_" + (j + 1)).attr("id", "tr_" + j);
        }
        if (_index = order3) {
            if (confirm('确定要删除吗?')) {
                var retObj = jcdpCallService("CheckDevQuestion", "deleteCheckQuestionInfo", "question_id=" + itemId);
                if (typeof retObj.operationFlag != "undefined") {
                    var dOperationFlag = retObj.operationFlag;
                    if ('' != dOperationFlag) {
                        if ("failed" == dOperationFlag) {
                            alert("删除失败！");
                        }
                        if ("success" == dOperationFlag) {
                            alert("删除成功！");
                            //删除行
                            $(item).parent().parent().remove();
                            //索引减一
                            order3 = order3 - 1;
                            queryData(cruConfig.currentPage);
                        }
                    }
                }
            }
        }
        //索引减一
        order3 = order3 - 1;
    }
</script>
<script>
    // 设备交付验收单-开始
    function excelDataAddSkill(status) {
        insertTrPublicSkill('ck_list');
    }
    var orders1 = 0;
    function insertTrPublicSkill(obj) {
        var tmp = "public";
        $("#" + obj + "").append(
            "<tr id='ck_list'>" +
                "<td class='inquire_item5' style='text-align:right'>附件：</td>" +
                "<td class='inquire_form5'><input type='file' name='ck_list__" + tmp + orders1 + "' id=ck_list__" + tmp + orders1 + "' onchange='getFileInfoPublicSkill(this)'  style='text-align:left' class='input_width'/></td>" +
                "<td class='ali_btn'><span class='sc'><a href='javascript:void(0);' onclick='deleteInputPublicSkill(this)'  title='删除'></a></span></td>" +
            "</tr>"
        );
        orders1++;
    }
  	// 显示已插入的文件
	function insertFilePublicSkill(name,id){
		$("#ck_list").append(
			"<tr>"+
				"<td class='inquire_form5' style='width:25%;text-align:right;'>附件:</td>"+
     			"<td class='inquire_form5' colspan='3' style='text-align:left;width:35%'><a href='<%=contextPath%>/doc/downloadDoc.srq?docId="+id+"'>"+name+"</a></td>"+
				"<td class='inquire_form5' style='width:40%'><span class='sc'><a href='javascript:void(0);' onclick=deleteFilePublicSkill(this,\""+id+"\") title='删除'></a></span></td>"+
			"</tr>"
		);
	}
	function deleteFilePublicSkill(item,id){
		var tmp="public";
		$.messager.confirm("操作提示", "您确定要执行删除操作吗？", function (data) {
			if(data){
				$(item).parent().parent().parent().empty();
				jcdpCallService("ucmSrv", "deleteFile", "docId="+id);
				flag_public = 1;
			}
        });
	}
	function getFileInfoPublicsSkill(item){
		var docPath = $(item).val();
		var order = $(item).attr("id").split("_")[1];
		var docName = docPath.substring(docPath.lastIndexOf("\\")+1);
		var docTitle = docName.substring(0,docName.lastIndexOf("\."));
		$("#ck_list_"+order).val(docTitle);//文件name
	}
	function deleteInputPublicSkill(item){
		flag_public = 0;
		$(item).parent().parent().parent().remove();
	}
	// 设备交付验收单-结束
	
    
 	// 设备验收报告-开始
    function excelDataAddTest(status) {
        insertTrPublicTest('nck_list');
    }
    var orders2 = 0;
    function insertTrPublicTest(obj) {
        var tmp = "public";
        $("#" + obj + "").append(
            "<tr id='nck_list'>" +
                "<td class='inquire_item5' style='text-align:right'>附件：</td>" +
                "<td class='inquire_form5'><input type='file' name='nck_list__" + tmp + orders2 + "' id='nck_list__" + tmp + orders2 + "' onchange='getFileInfoPublicTest(this)' style='text-align:left' class='input_width'/></td>" +
                "<td class='ali_btn'><span class='sc'><a href='javascript:void(0);' onclick='deleteInputPublicTest(this)'  title='删除'></a></span></td>" +
            "</tr>"
        );
        orders2++;
    }
    //显示已插入的文件
	function insertFilePublicTest(name,id){
		$("#nck_list").append(
			"<tr>"+
				"<td class='inquire_form5' style='width:25%;text-align:right;'>附件:</td>"+
     			"<td class='inquire_form5' colspan='3' style='text-align:left;width:35%'><a href='<%=contextPath%>/doc/downloadDoc.srq?docId="+id+"'>"+name+"</a></td>"+
				"<td class='inquire_form5' style='width:40%'><span class='sc'><a href='javascript:void(0);' onclick=deleteFilePublicTest(this,\""+id+"\") title='删除'></a></span></td>"+
			"</tr>"
		);
	}
	function deleteFilePublicTest(item,id){
		var tmp="public";
		$.messager.confirm("操作提示", "您确定要执行删除操作吗？", function (data) {
			if(data){
				$(item).parent().parent().parent().empty();
				jcdpCallService("ucmSrv", "deleteFile", "docId="+id);
				flag_public = 1;
			}
        });
	}
	function getFileInfoPublicsTest(item){
		var docPath = $(item).val();
		var order = $(item).attr("id").split("_")[1];
		var docName = docPath.substring(docPath.lastIndexOf("\\")+1);
		var docTitle = docName.substring(0,docName.lastIndexOf("\."));
		$("#nck_list_"+order).val(docTitle);//文件name
	}
	function deleteInputPublicTest(item){
		flag_public = 0;
		$(item).parent().parent().parent().remove();
	}
 	// 设备验收报告-结束
 
    
 	// 设备验收信息表-开始
    function excelDataAddUser(status) {
        insertTrPublicUser('ck_posts');
    }
    var orders3 = 0;
    function insertTrPublicUser(obj) {
        var tmp = "public";
        $("#" + obj + "").append(
            "<tr id='ck_posts'>" +
                "<td class='inquire_item5' style='text-align:right'>附件：</td>" +
                "<td class='inquire_form5'><input type='file' name='ck_posts__" + tmp + orders3 + "' id='ck_posts__" + tmp + orders3 + "' onchange='getFileInfoPublicUser(this)' style='text-align:left' class='input_width'/></td>" +
                "<td class='ali_btn'><span class='sc'><a href='javascript:void(0);' onclick='deleteInputPublicUser(this)'  title='删除'></a></span></td>" +
            "</tr>"
        );
        orders3++;
    }
  	// 显示已插入的文件
    function insertFilePublicUser(name, id) {
        $("#ck_posts").append(
            "<tr>" +
                "<td class='inquire_form5' style='width:25%;text-align:right;'>附件:</td>" +
                "<td class='inquire_form5' colspan='3' style='text-align:left;width:35%'><a href='<%=contextPath%>/doc/downloadDoc.srq?docId=" + id + "'>" + name + "</a></td>" +
                "<td class='inquire_form5' style='width:40%'><span class='sc'><a href='javascript:void(0);' onclick=deleteFilePublicUser(this,\"" + id + "\") title='删除'></a></span></td>" +
            "</tr>"
        );
    }
    function deleteFilePublicUser(item, id) {
        var tmp = "public";
        $.messager.confirm("操作提示", "您确定要执行删除操作吗？", function (data) {
            if (data) {
                $(item).parent().parent().parent().empty();
                jcdpCallService("ucmSrv", "deleteFile", "docId=" + id);
                flag_public = 1;
            }
        });
    }
    function getFileInfoPublicsUser(item) {
        var docPath = $(item).val();
        var order = $(item).attr("id").split("_")[1];
        var docName = docPath.substring(docPath.lastIndexOf("\\") + 1);
        var docTitle = docName.substring(0, docName.lastIndexOf("\."));
        $("#ck_posts_" + order).val(docTitle);//文件name
    }
    function deleteInputPublicUser(item) {
        flag_public = 0;
        $(item).parent().parent().parent().remove();
    }
 	// 设备验收信息表-结束
    
 	
  	// 存档资料-开始
    function excelDataAdd(status) {
        insertTrPublic('ck_post_many');
    }
    var orders4 = 0;
    function insertTrPublic(obj) {
        var tmp = "public";
        $("#" + obj + "").append(
            "<tr id='ck_post_many'>" +
                "<td class='inquire_item5' style='text-align:right'>附件：</td>" +
                "<td class='inquire_form5'><input type='file' name='ck_post_many__" + tmp + orders4 + "' id='ck_post_many__" + tmp + orders4 + "' onchange='getFileInfoPublic(this)' style='text-align:left' class='input_width'/></td>" +
                "<td class='ali_btn'><span class='sc'><a href='javascript:void(0);' onclick='deleteInputPublic(this)'  title='删除'></a></span></td>" +
            "</tr>"
        );
        orders4++;
    }
  	// 显示已插入的文件
	function insertFilePublic(name,id){
		$("#ck_post_many").append(
			"<tr>"+
				"<td class='inquire_form5' style='width:25%;text-align:right;'>附件:</td>"+
     			"<td class='inquire_form5' colspan='3' style='text-align:left;width:35%'><a href='<%=contextPath%>/doc/downloadDoc.srq?docId="+id+"'>"+name+"</a></td>"+
				"<td class='inquire_form5' style='width:40%'><span class='sc'><a href='javascript:void(0);' onclick=deleteFilePublic(this,\""+id+"\") title='删除'></a></span></td>"+
			"</tr>"
		);
	}
	function deleteFilePublic(item,id){
		var tmp="public";
		$.messager.confirm("操作提示", "您确定要执行删除操作吗？", function (data) {
			if(data){
			$(item).parent().parent().parent().empty();
			jcdpCallService("ucmSrv", "deleteFile", "docId="+id);
			flag_public = 1;
			}
        });
	}
	function getFileInfoPublics(item){
		var docPath = $(item).val();
		var order = $(item).attr("id").split("_")[1];
		var docName = docPath.substring(docPath.lastIndexOf("\\")+1);
		var docTitle = docName.substring(0,docName.lastIndexOf("\."));
		$("#ck_post_many_"+order).val(docTitle);//文件name
	}
	function deleteInputPublic(item){
		flag_public = 0;
		$(item).parent().parent().parent().remove();
	}
 	// 存档资料-结束
</script>
</html>
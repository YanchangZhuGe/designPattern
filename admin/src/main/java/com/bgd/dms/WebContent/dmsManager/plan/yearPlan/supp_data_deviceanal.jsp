<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.util.*,com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();
	ISrvMsg responseDTO = (ISrvMsg)request.getAttribute("responseDTO");
	//需求报表是否保存成功
  	//String operationFlag = responseDTO.getValue("operationFlag");
  	//申请id
  	String applyId = responseDTO.getValue("applyId");
  	//申请年度
  	String applyYear = responseDTO.getValue("applyYear");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
	<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
	<link href="<%=contextPath%>/dmsManager/plan/yearPlan/panel.css" rel="stylesheet" type="text/css" />
	<link href="<%=contextPath%>/css/calendar-blue.css" rel="stylesheet" type="text/css" /> 
	<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
	<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
	<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
	<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
	<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
	<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
	<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
	<title>设备现状分析表</title>
</head>

<body style="background:#cdddef"  scroll="no">
	<div id="inq_tool_box">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
				<td background="<%=contextPath%>/images/list_15.png">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr>
							<td>&nbsp;
								<input type="button" value="选择设备" style="width:80px;height:25px;" onclick="selectSingleDev()"/>	
							</td>
							<auth:ListButton functionId="" css="tj" event="onclick='toSubmit()'" title="保存"></auth:ListButton>
							<auth:ListButton functionId="" css="gb" event="onclick='toClose()'" title="关闭"></auth:ListButton>
				  		</tr>
					</table>
				</td>
			   	<td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
			</tr>
		</table>
	</div>
	<div id="title_box_0" class="tongyong_box_title">
		<span id="list_div_0_span" style="display:block;text-align:center;">设备现状分析表</span>
	</div>
	<form name="form" id="form" method="post" action="<%=contextPath%>/dms/plan/yearPlan/saveOrUpdateDeviceAnalInfo.srq">
		<!--申请id -->
		<input name="apply_id" id="apply_id" type="hidden" value="<%=applyId%>"/>
		<!--申请年度 -->
		<input name="apply_year" id="apply_year" type="hidden" value="<%=applyYear%>"/>
		<div id="table_box_0" style="overflow-x:scroll;overflow-y:auto;">
			<table  style="table-layout:fixed"  border="0" cellspacing="0" cellpadding="0"
				class="tab_info" id=queryRetTable_0>
				<tr>
					<td width="50px" class="bt_info_odd" rowspan="3"></td>
					<td width="100px" class="bt_info_even" rowspan="3">设备大类</td>
					<td width="100px" class="bt_info_odd" rowspan="3">中类</td>
					<td width="100px" class="bt_info_even" rowspan="3">小类</td>
					<td width="100px" class="bt_info_odd" rowspan="3">小小类</td>
					<td width="100px" class="bt_info_even" rowspan="3">设备名称</td>
					<td width="100px" class="bt_info_odd" rowspan="3">规格型号</td>
					<td width="300px" class="bt_info_even" rowspan="2" colspan="3">总量</td>
					<td width="900px" class="bt_info_odd" colspan="9">使用年限</td>
				</tr>
				<tr>
					<td class="bt_info_even" colspan="3">4-6年</td>
					<td class="bt_info_odd" colspan="3">7-8年</td>
					<td class="bt_info_even" colspan="3">8年以上(不含8年)</td>
				</tr>
				<tr>
					<td class="bt_info_odd">数量</td>
					<td class="bt_info_even">原值</td>
					<td class="bt_info_odd">净值</td>
					<td class="bt_info_even">数量</td>
					<td class="bt_info_odd">原值</td>
					<td class="bt_info_even">净值</td>
					<td class="bt_info_odd">数量</td>
					<td class="bt_info_even">原值</td>
					<td class="bt_info_odd">净值</td>
					<td class="bt_info_even">数量</td>
					<td class="bt_info_odd">原值</td>
					<td class="bt_info_even">净值</td>
				</tr>
			</table>
		</div>
	</form>
</body>
<script type="text/javascript">
	//设置表格高度
	function frameSize(){
		$("#table_box_0").css("height",$(window).height()-$("#inq_tool_box").height()-$("#title_box_0").height()-10);
	}
	//页面初始化信息
	$(function(){
		frameSize();
		$(window).resize(function(){
	  		frameSize();
		});
		//申请单id
		var applyId="<%=applyId%>";
		//默认加载设备现状分析表信息
		loadUpdateFormData(applyId);
	});
	//加载修改设备现状分析表单数据
	function loadUpdateFormData(applyId){
		var retObj = jcdpCallService("YearPlanSrv", "getDeviceAnalData","applyId="+applyId);
		if(typeof retObj.datas!="undefined"){
			var data = retObj.datas;
			for(var i=0;i<data.length;i++){
				var ts=insertTr("old");
				var tData=data[i];
				//遍历data[i]数据，给设备现状分析表赋值
				$.each(tData, function(i, n){
					if("apply_id"!=i){
						if(null!=n && ""!=n){
							$("#queryRetTable_0 #"+i+"_"+ts).val(n);
							if("deviceanal_id"!=i && "dev_g_type"!=i && "dev_m_type"!=i && "dev_s_type"!=i && "dev_ls_type"!=i && "dev_type"!=i){
								$("#queryRetTable_0 #"+i+"_"+ts).parent().append(n);
							}
						}
					}
				});
			}
		}
	}
	//检查数值
	function checkNumber(item,isFlag){
		//校验整数
		if("0"==isFlag){
			var re = /^\+?[1-9][0-9]*$/;
			//检查所有的数量字段 
			if(!re.test(item.value)){
				alert("输入必须为整数!");
				item.value = "";
			}
		}
		//校验实数
		if("1"==isFlag){
			var re =/^-?\d+\.?\d{0,2}$/;
			//检查所有的数量字段 
			if(!re.test(item.value)){
				alert("最多请输入两位小数!");
				item.value = "";
			}
		}
	}
	
	//添加设备现状分析表行
	function insertTr(old){
		var ts=new Date().getTime();//获取时间戳
		var temp = "";
		if(old=="old"){
			temp +="<tr class='old'>";
		}else{
			temp +="<tr class='new'>";
		}
		temp =temp +("<td><input name='deviceanal_id_"+ts+"' id='deviceanal_id_"+ts+"' type='hidden'/>"+
		"<img src='<%=contextPath%>/images/delete.png' width='16' height='16' style='cursor:hand;' onclick='deleteTr(this,"+ts+")'/></td>"+		
		"<td><input name='dev_g_type_"+ts+"' id='dev_g_type_"+ts+"' type='hidden'/>"+
		"<input name='dev_g_name_"+ts+"' id='dev_g_name_"+ts+"' type='hidden'/></td>"+
		"<td><input name='dev_m_type_"+ts+"' id='dev_m_type_"+ts+"' type='hidden'/>"+
		"<input name='dev_m_name_"+ts+"' id='dev_m_name_"+ts+"' type='hidden'/></td>"+
		"<td><input name='dev_s_type_"+ts+"' id='dev_s_type_"+ts+"' type='hidden'/>"+
		"<input name='dev_s_name_"+ts+"' id='dev_s_name_"+ts+"' type='hidden'/></td>"+
		"<td><input name='dev_ls_type_"+ts+"' id='dev_ls_type_"+ts+"' type='hidden'/>"+
		"<input name='dev_ls_name_"+ts+"' id='dev_ls_name_"+ts+"' type='hidden'/></td>"+
		"<td><input name='dev_type_"+ts+"' id='dev_type_"+ts+"' type='hidden'/>"+
		"<input name='dev_name_"+ts+"' id='dev_name_"+ts+"' type='hidden'/></td>"+
		"<td><input name='dev_model_"+ts+"' id='dev_model_"+ts+"' type='hidden'/></td>"+
		"<td><input name='total_number_"+ts+"' id='total_number_"+ts+"' type='hidden'/></td>"+
		"<td><input name='tatal_orig_value_"+ts+"' id='tatal_orig_value_"+ts+"' type='hidden'/></td>"+
		"<td><input name='tatal_net_value_"+ts+"' id='tatal_net_value_"+ts+"' type='hidden'/></td>"+
		"<td><input name='f_s_number_"+ts+"' id='f_s_number_"+ts+"' type='hidden'/></td>"+
		"<td><input name='f_s_orig_value_"+ts+"' id='f_s_orig_value_"+ts+"' type='hidden'/></td>"+
		"<td><input name='f_s_net_value_"+ts+"' id='f_s_net_value_"+ts+"' type='hidden'/></td>"+
		"<td><input name='s_e_number_"+ts+"' id='s_e_number_"+ts+"' type='hidden'/></td>"+
		"<td><input name='s_e_orig_value_"+ts+"' id='s_e_orig_value_"+ts+"' type='hidden'/></td>"+
		"<td><input name='s_e_net_value_"+ts+"' id='s_e_net_value_"+ts+"' type='hidden'/></td>"+
		"<td><input name='e_more_number_"+ts+"' id='e_more_number_"+ts+"' type='hidden'/></td>"+
		"<td><input name='e_more_orig_value_"+ts+"' id='e_more_orig_value_"+ts+"' type='hidden'/></td>"+
		"<td><input name='e_more_net_value_"+ts+"' id='e_more_net_value_"+ts+"' type='hidden'/></td>"+
		"</tr>");
		$("#queryRetTable_0").append(temp);
		return ts;
	}
	//删除设备现状分析表行
	function deleteTr(item,timestamp){
		//页面修改时要处理的操作
		if($(item).parent().parent().attr("class")=="old"){
			var deviceanalId = $("#deviceanal_id_"+timestamp).val();
			var tts=new Date().getTime();
			$("#form").append("<input type='hidden' name='del_devanal_"+tts+"' value='"+deviceanalId+"'/>");
		}
		//删除行
		$(item).parent().parent().remove();
	}
	//关闭操作
	function toClose(){
		parent.location.href='<%=contextPath %>/dmsManager/plan/yearPlan/apply_list.jsp';	
	}
	//提交方法
	function toSubmit(){
		var subForm = $("#form");
		subForm.submit();
	}
	//选择单台设备
	function selectSingleDev(){
		var obj = new Object();
		var checkedCodes = "";
		var selectedDev=$("#queryRetTable_0 input[id^='dev_type']");
		if(selectedDev && selectedDev.length>0){
			for (var i = 0; i < selectedDev.length; i++) {
				checkedCodes += ",'" + selectedDev[i].value+"'";
			} 
			checkedCodes = checkedCodes=="" ? "" : checkedCodes.substr(1);
			obj.checkedCodes=checkedCodes;
		}
		var vReturnValue = window.showModalDialog("<%=contextPath%>/dmsManager/plan/yearPlan/selectSingleDev.jsp",obj,"dialogWidth=550px;dialogHeight=480px");
		if(typeof vReturnValue!="undefined"){
			var retObj = jcdpCallService("YearPlanSrv", "getDevAnalDataBySCode","devTypeStr="+vReturnValue);
			var data = retObj.datas;
			for(var i=0;i<data.length;i++){
				var ts=insertTr();
				var tData=data[i];
				//遍历data[i]数据，给设备现状分析表赋值
				$.each(tData, function(i, n){
					if(null!=n && ""!=n){
						$("#queryRetTable_0 #"+i+"_"+ts).val(n);
						if("dev_g_type"!=i && "dev_m_type"!=i && "dev_s_type"!=i && "dev_ls_type"!=i && "dev_type"!=i){
							$("#queryRetTable_0 #"+i+"_"+ts).parent().append(n);
						}
					}
				});
			}
		}
	}
</script>
</html>


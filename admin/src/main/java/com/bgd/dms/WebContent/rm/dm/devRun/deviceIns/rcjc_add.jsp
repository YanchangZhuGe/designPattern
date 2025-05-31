<%@page contentType="text/html;charset=utf-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@ page import="java.util.Map"%>
<%@ taglib uri="code" prefix="code"%>
<%@ page import="com.cnpc.jcdp.common.UserToken"%>
<%@ page import="com.cnpc.jcdp.soa.msg.MsgElement"%>
<%@ page import="java.util.Date"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="com.cnpc.jcdp.webapp.util.JcdpMVCUtil"%>
<%@ taglib prefix="auth" uri="auth"%>
<%@ page import="com.cnpc.jcdp.cfg.BeanFactory"%>
<%@ page import="java.util.*"%>


<%
	String contextPath = request.getContextPath(); 
	String flag = request.getParameter("flag");
	if(null==flag){
		flag="";
	}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
		<title>日常检查</title>
		<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
		<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
		<link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" />
		<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
		<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
		<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
		<script type="text/javascript" src="<%=contextPath%>/js/dialog_open1.js"></script>
		<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
		<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
		<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
	</head>
	<body onload="" style="height: 560px;">
		<form name="form" id="form" method="post" action="<%=contextPath%>/rm/dm/saveOrUpdateMRcjcInfo.srq?flag=<%=flag%>">
			<!-- 主键 -->
			<input id="devinspectioin_id" name="devinspectioin_id" type="hidden" />
			<!-- 类型1可控震源2轻便钻机3运输车辆4车装钻机-->
			<input id="type" name="type" type="hidden" />
			<!-- 未选中的检查项 -->
			<input  type ="hidden" id="unchecked_items" name="unchecked_items" />
			<div id="new_table_box" style="height: 560px;">
				<div id="new_table_box_content" style="height: 530px;">
					<div id="new_table_box_bg" style="height: 460px;">
						<fieldset>
							<legend>设备信息</legend>
							<table width="97%" border="0" cellspacing="0" cellpadding="0"
								class="tab_line_height">
								<tr>
									<td class="inquire_item6">设备名称：</td>
									<td class="inquire_form6">
										<input id="dev_acc_id" name="dev_acc_id" type="hidden" /> 
										<input id="dev_name" name="dev_name" class="input_width" type="text" readonly /> 
										<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="showDevAccountPage()"/>
									</td>
									<td class="inquire_item6">规格型号：</td>
									<td class="inquire_form6">
										<input id="dev_model" name="dev_model" class="input_width" type="text" readonly />
									</td>
								</tr>
								<tr>
									<td class="inquire_item6">自编号：</td>
									<td class="inquire_form6">
										<input id="self_num" name="self_num" class="input_width" type="text" readonly />
									</td>
									<td class="inquire_item6">牌照号：</td>
									<td class="inquire_form6">
										<input name="license_num" id="license_num" class="input_width" type="text" readonly />
									</td>
								</tr>
								<tr>
									<td class="inquire_item6">实物标识号：</td>
									<td class="inquire_form6">
										<input name="dev_sign" id="dev_sign" class="input_width" type="text" readonly />
									</td>
									<td class="inquire_item6"></td>
									<td class="inquire_form6"></td>
								</tr>
							</table>
						</fieldset>
						<div id ="load_checked_Items" ></div>
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
		cruConfig.contextPath =  "<%=contextPath%>";
		cruConfig.cdtType = 'form';

		//加载整改内容
		function loadMCContent(){
			var unCheckedBoxs = $("input[name='zyk']").not("input:checked");
			var mcContent="";
			if(unCheckedBoxs.length>0){
				for(var j=0;j<unCheckedBoxs.length;j++){
					var uid=$(unCheckedBoxs[j]).attr("id");
					mcContent+=$(unCheckedBoxs[j]).parent().parent().find("td").first().text()+"："+$("#s"+uid).text()+";";
				}
			}
			$("#modification_content").val(mcContent);
		}
		//提交
		function submitInfo(){
			//获取未选中的检查项
			var unCheckedItems="";
			$.each($("input[name='zyk']").not("input:checked"), function(i, n){
				if (unCheckedItems == ''){
					unCheckedItems += n.value;
				}else{
					unCheckedItems += ","+n.value;
				}
			});
			$("#unchecked_items").val(unCheckedItems);
			document.getElementById("form").submit();
		}
		
		function showDevAccountPage(){
			var obj = new Object();
			var dialogurl = "<%=contextPath%>/rm/dm/devRun/deviceIns/selectRcjcAccount.jsp";
			dialogurl = encodeURI(dialogurl);
			dialogurl = encodeURI(dialogurl);
			var vReturnValue = window.showModalDialog(dialogurl , obj ,"dialogWidth=950px;dialogHeight=480px");
			if(vReturnValue!=undefined){
				$("#load_checked_Items").empty();
				//返回信息是 队级台账id + 设备编码 + 设备名称 + 规格型号 + 自编号 + 实物标识号 + 牌照号
				var content= vReturnValue.split('~');
				document.getElementById("dev_acc_id").value=content[0];
				document.getElementById("dev_name").value=content[2];
				document.getElementById("dev_model").value=content[3];
				document.getElementById("self_num").value=content[4];
				document.getElementById("dev_sign").value=content[5];
				document.getElementById("license_num").value=content[6];
				var reDevType=content[1];
				var rcjcType="";
				if(reDevType.indexOf("S0623")==0){
					rcjcType="1";//可控震源
				} 
				if(reDevType.indexOf("S060102")==0){//轻便钻机
					rcjcType="2";
				} 
				if(reDevType.indexOf("S08")==0){//运输车辆
					rcjcType="3";
				} 
				if(reDevType.indexOf("S060101")==0 || reDevType.indexOf("S060199")==0){//车装钻机
					rcjcType="4";
				}
				if("1"==rcjcType){
					$("#load_checked_Items").load("<%=contextPath%>/rm/dm/devRun/deviceIns/kkzy_rcjc.jsp");
				}
				if("2"==rcjcType){
					$("#load_checked_Items").load("<%=contextPath%>/rm/dm/devRun/deviceIns/qbzj_rcjc.jsp");			
				}
				if("3"==rcjcType){
					$("#load_checked_Items").load("<%=contextPath%>/rm/dm/devRun/deviceIns/yscl_rcjc.jsp");
				}
				if("4"==rcjcType){
					$("#load_checked_Items").load("<%=contextPath%>/rm/dm/devRun/deviceIns/czzj_rcjc.jsp");
				}
				document.getElementById("type").value=rcjcType;
			}
		}
		//清除缓存
		$.ajaxSetup ({
			cache: false //close AJAX cache
		});
	</script>
</html>
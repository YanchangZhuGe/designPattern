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
	UserToken user = OMSMVCUtil.getUserToken(request);
	String userName = (user==null)?"":user.getUserName();
	SimpleDateFormat format =new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	String curDate = format.format(new Date());	
	String devinspectioin_id = request.getParameter("devinspectioin_id");
	if(null==devinspectioin_id){
		devinspectioin_id="";
	}
	String flag = request.getParameter("flag");
	if(null==flag){
		flag="";
	}
	String type = request.getParameter("type");
	if(null==type){
		type="";
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
						<!-- 可控震源-->
						<% 
							if("1".equals(type)){ 
						%>
						<fieldset>
							<legend>日常检查项目</legend>
							<table border="0" cellpadding="0" cellspacing="0" class="tab_line_height" width="100%">
								<tr>
									<td class="inquire_item6"></td>
									<td class="inquire_form6"></td>
									<td class="inquire_item6"></td>
									<td class="inquire_form6"></td>
									<td class="inquire_item6">检查记录时间：</td>
									<td class="inquire_form6">
										<input type="text" name="inspectioin_time" id="inspectioin_time" class="input_width" readonly="readonly"/>
										<img src="<%=contextPath%>/images/calendar.gif" id="tributton2" width='16' height='16' style="cursor: hand;" onmouseover="calDateSelector(inspectioin_time,tributton2);"/>
									</td>
								</tr>
							</table>
							<table width="250%" border="0" cellspacing="0" cellpadding="0" class="tab_info" style="margin-top: 2px;">
								<tr>
									<td class="bt_info_odd">&nbsp;&nbsp;&nbsp;</td>
									<td class="bt_info_even">发动机部分</td>
									<td class="bt_info_odd">振动器及液压部分</td>
									<td class="bt_info_even">驱动部分</td>
									<td class="bt_info_odd">相关工作</td>
								</tr>
								<tr>
									<td style="border-bottom: black solid 1px;" align="center">启动前</td>
									<td style="border-bottom: black solid 1px; padding-left: 10px;" align="left" valign="top">
									<%
										String sql = " select dl.superior_code_id,dl.coding_sort_id,dl.coding_code_id,dl.coding_name from comm_coding_sort_detail dl where dl.coding_sort_id = '5110000158' and dl.superior_code_id = '5110000158000000005' and dl.bsflag = '0' ";
										List list = BeanFactory.getQueryJdbcDAO().queryRecords(sql);
										for (int i = 0; i < list.size(); i++) {
											Map map = (Map) list.get(i);
											String codingName = (String) map.get("codingName");
											String codingCodeId = (String) map.get("codingCodeId");
									%> 
									<input type="checkbox" id="zyk<%=codingCodeId%>" name="zyk" value="<%=codingCodeId%>" checked="checked" onclick="loadMCContent()"/> 
									<span id="szyk<%=codingCodeId%>"><%=codingName%></span><br/> 
									<%
	 									}
	 								%>
									</td>
									<td style="border-bottom: black solid 1px; padding-left: 10px;"
										align="left" valign="top">
										<%
											String sqlA = " select dl.superior_code_id,dl.coding_sort_id,dl.coding_code_id,dl.coding_name from comm_coding_sort_detail dl where dl.coding_sort_id = '5110000158' and dl.superior_code_id = '5110000158000000008' and dl.bsflag = '0' ";
											List listA = BeanFactory.getQueryJdbcDAO().queryRecords(sqlA);
											for (int a = 0; a < listA.size(); a++) {
												Map mapA = (Map) listA.get(a);
												String codingName = (String) mapA.get("codingName");
												String codingCodeId = (String) mapA.get("codingCodeId");
										%> 
										<input type="checkbox" id="zyk<%=codingCodeId%>" name="zyk" value="<%=codingCodeId%>" checked="checked" onclick="loadMCContent()" /> 
										<span id="szyk<%=codingCodeId%>"><%=codingName%></span><br/> 
										<%
											}
										%>
									</td>
									<td style="border-bottom: black solid 1px; padding-left: 10px;"
										align="left" valign="top">
										<%
											String sqlB = " select dl.superior_code_id,dl.coding_sort_id,dl.coding_code_id,dl.coding_name from comm_coding_sort_detail dl where dl.coding_sort_id = '5110000158' and dl.superior_code_id = '5110000158000000011' and dl.bsflag = '0' ";
											List listB = BeanFactory.getQueryJdbcDAO().queryRecords(sqlB);
											for (int b = 0; b < listB.size(); b++) {
												Map mapB = (Map) listB.get(b);
												String codingName = (String) mapB.get("codingName");
												String codingCodeId = (String) mapB.get("codingCodeId");
										%> 
										<input type="checkbox" id="zyk<%=codingCodeId%>" name="zyk" value="<%=codingCodeId%>" checked="checked" onclick="loadMCContent()" /> 
										<span id="szyk<%=codingCodeId%>"><%=codingName%></span> <br/> 
										<%
											}
										%>
									</td>
									<td style="border-bottom: black solid 1px; padding-left: 10px;"
										align="left" valign="top">
										<%
											String sqlC = " select dl.superior_code_id,dl.coding_sort_id,dl.coding_code_id,dl.coding_name from comm_coding_sort_detail dl where dl.coding_sort_id = '5110000158' and dl.superior_code_id = '5110000158000000014' and dl.bsflag = '0' ";
											List listC = BeanFactory.getQueryJdbcDAO().queryRecords(sqlC);
											for (int c = 0; c < listC.size(); c++) {
												Map mapC = (Map) listC.get(c);
												String codingName = (String) mapC.get("codingName");
												String codingCodeId = (String) mapC.get("codingCodeId");
										%> 
										<input type="checkbox" id="zyk<%=codingCodeId%>" name="zyk" value="<%=codingCodeId%>" checked="checked" onclick="loadMCContent()"/> 
										<span id="szyk<%=codingCodeId%>"><%=codingName%></span><br/> 
										<%
										 	}
										%>
									</td>
								</tr>
								<tr>
									<td style="border-bottom: black solid 1px;" align="center">启动后</td>
									<td style="border-bottom: black solid 1px; padding-left: 10px;"
										align="left" valign="top">
										<%
											String sqlD = " select dl.superior_code_id,dl.coding_sort_id,dl.coding_code_id,dl.coding_name from comm_coding_sort_detail dl where dl.coding_sort_id = '5110000158' and dl.superior_code_id = '5110000158000000006' and dl.bsflag = '0' ";
											List listD = BeanFactory.getQueryJdbcDAO().queryRecords(sqlD);
											for (int d = 0; d < listD.size(); d++) {
												Map mapD = (Map) listD.get(d);
												String codingName = (String) mapD.get("codingName");
												String codingCodeId = (String) mapD.get("codingCodeId");
										%> 
										<input type="checkbox" id="zyk<%=codingCodeId%>" name="zyk" value="<%=codingCodeId%>" checked="checked" onclick="loadMCContent()" /> 
										<span id="szyk<%=codingCodeId%>"><%=codingName%></span><br/> 
										<%
	 										}
	 									%>
									</td>
									<td style="border-bottom: black solid 1px; padding-left: 10px;"
										align="left" valign="top">
										<%
											String sqlE = " select dl.superior_code_id,dl.coding_sort_id,dl.coding_code_id,dl.coding_name from comm_coding_sort_detail dl where dl.coding_sort_id = '5110000158' and dl.superior_code_id = '5110000158000000009' and dl.bsflag = '0' ";
											List listE = BeanFactory.getQueryJdbcDAO().queryRecords(sqlE);
											for (int e = 0; e < listE.size(); e++) {
												Map mapE = (Map) listE.get(e);
												String codingName = (String) mapE.get("codingName");
												String codingCodeId = (String) mapE.get("codingCodeId");
										%> 
										<input type="checkbox" id="zyk<%=codingCodeId%>" name="zyk" value="<%=codingCodeId%>" checked="checked" onclick="loadMCContent()" /> 
										<span id="szyk<%=codingCodeId%>"><%=codingName%></span><br/> 
										<%
	 										}
	 									%>
									</td>
									<td style="border-bottom: black solid 1px; padding-left: 10px;"
										align="left" valign="top">
										<%
											String sqlF = " select dl.superior_code_id,dl.coding_sort_id,dl.coding_code_id,dl.coding_name from comm_coding_sort_detail dl where dl.coding_sort_id = '5110000158' and dl.superior_code_id = '5110000158000000012' and dl.bsflag = '0' ";
											List listF = BeanFactory.getQueryJdbcDAO().queryRecords(sqlF);
											for (int f = 0; f < listF.size(); f++) {
												Map mapF = (Map) listF.get(f);
												String codingName = (String) mapF.get("codingName");
												String codingCodeId = (String) mapF.get("codingCodeId");
										%> 
										<input type="checkbox" id="zyk<%=codingCodeId%>" name="zyk" value="<%=codingCodeId%>" checked="checked" onclick="loadMCContent()" /> 
										<span id="szyk<%=codingCodeId%>"><%=codingName%></span><br/> 
										<%
	 										}
	 									%>
									</td>
									<td style="border-bottom: black solid 1px; padding-left: 10px;"
										align="left" valign="top">
										<%
											String sqlG = " select dl.superior_code_id,dl.coding_sort_id,dl.coding_code_id,dl.coding_name from comm_coding_sort_detail dl where dl.coding_sort_id = '5110000158' and dl.superior_code_id = '5110000158000000015' and dl.bsflag = '0' ";
											List listG = BeanFactory.getQueryJdbcDAO().queryRecords(sqlG);
											for (int g = 0; g < listG.size(); g++) {
												Map mapG = (Map) listG.get(g);
												String codingName = (String) mapG.get("codingName");
												String codingCodeId = (String) mapG.get("codingCodeId");
										%> 
										<input type="checkbox" id="zyk<%=codingCodeId%>" name="zyk" value="<%=codingCodeId%>" checked="checked" onclick="loadMCContent()" /> 
										<span id="szyk<%=codingCodeId%>"><%=codingName%></span><br/> 
										<%
	 										}
	 									%>
									</td>
								</tr>
								<tr>
									<td style="border-bottom: black solid 1px;" align="center">停机后</td>
									<td style="border-bottom: black solid 1px; padding-left: 10px;"
										align="left" valign="top">
										<%
											String sqlH = " select dl.superior_code_id,dl.coding_sort_id,dl.coding_code_id,dl.coding_name from comm_coding_sort_detail dl where dl.coding_sort_id = '5110000158' and dl.superior_code_id = '5110000158000000007' and dl.bsflag = '0' ";
											List listH = BeanFactory.getQueryJdbcDAO().queryRecords(sqlH);
											for (int h = 0; h < listH.size(); h++) {
												Map mapH = (Map) listH.get(h);
												String codingName = (String) mapH.get("codingName");
												String codingCodeId = (String) mapH.get("codingCodeId");
										%> 
										<input type="checkbox" id="zyk<%=codingCodeId%>" name="zyk" value="<%=codingCodeId%>" checked="checked" onclick="loadMCContent()" /> 
										<span id="szyk<%=codingCodeId%>"><%=codingName%></span><br/> 
										<%
	 										}
	 									%>
									</td>
									<td style="border-bottom: black solid 1px; padding-left: 10px;"
										align="left" valign="top">
										<%
											String sqlJ = " select dl.superior_code_id,dl.coding_sort_id,dl.coding_code_id,dl.coding_name from comm_coding_sort_detail dl where dl.coding_sort_id = '5110000158' and dl.superior_code_id = '5110000158000000010' and dl.bsflag = '0' ";
											List listJ = BeanFactory.getQueryJdbcDAO().queryRecords(sqlJ);
											for (int j = 0; j < listJ.size(); j++) {
												Map mapJ = (Map) listJ.get(j);
												String codingName = (String) mapJ.get("codingName");
												String codingCodeId = (String) mapJ.get("codingCodeId");
										%> 
										<input type="checkbox" id="zyk<%=codingCodeId%>" name="zyk" value="<%=codingCodeId%>" checked="checked" onclick="loadMCContent()" /> 
										<span id="szyk<%=codingCodeId%>"><%=codingName%></span><br/> 
										<%
	 										}
	 									%>
									</td>
									<td style="border-bottom: black solid 1px; padding-left: 10px;"
										align="left" valign="top">
										<%
											String sqlK = " select dl.superior_code_id,dl.coding_sort_id,dl.coding_code_id,dl.coding_name from comm_coding_sort_detail dl where dl.coding_sort_id = '5110000158' and dl.superior_code_id = '5110000158000000013' and dl.bsflag = '0' ";
											List listK = BeanFactory.getQueryJdbcDAO().queryRecords(sqlK);
											for (int k = 0; k < listK.size(); k++) {
												Map mapK = (Map) listK.get(k);
												String codingName = (String) mapK.get("codingName");
												String codingCodeId = (String) mapK.get("codingCodeId");
										%> 
										<input type="checkbox" id="zyk<%=codingCodeId%>" name="zyk" value="<%=codingCodeId%>" checked="checked" onclick="loadMCContent()" />
										<span id="szyk<%=codingCodeId%>"><%=codingName%></span><br/> 
										<%
	 										}
	 									%>
									</td>
									<td style="border-bottom: black solid 1px; padding-left: 10px;"
										align="left" valign="top">
										<%
											String sqlL = " select dl.superior_code_id,dl.coding_sort_id,dl.coding_code_id,dl.coding_name from comm_coding_sort_detail dl where dl.coding_sort_id = '5110000158' and dl.superior_code_id = '5110000158000000016' and dl.bsflag = '0' ";
											List listL = BeanFactory.getQueryJdbcDAO().queryRecords(sqlL);
											for (int l = 0; l < listL.size(); l++) {
												Map mapL = (Map) listL.get(l);
												String codingName = (String) mapL.get("codingName");
												String codingCodeId = (String) mapL.get("codingCodeId");
										%> 
										<input type="checkbox" id="zyk<%=codingCodeId%>" name="zyk" value="<%=codingCodeId%>" checked="checked" onclick="loadMCContent()" /> 
										<span id="szyk<%=codingCodeId%>"><%=codingName%></span><br/> 
										<%
	 										}
	 									%>
									</td>
								</tr>
							</table>
						</fieldset>
						<fieldset>
							<legend>燃油记录</legend>
							<table border="0" cellpadding="0" cellspacing="0" class="tab_line_height" width="100%">
								<tr>
									<td class="inquire_item6">燃油加油量(升)：</td>
									<td class="inquire_form6">
										<input type="text" name="oil_num" id="oil_num" class="input_width"/>
									</td>
									<td class="inquire_item6"></td>
									<td class="inquire_form6"></td>
									<td class="inquire_item6"></td>
									<td class="inquire_form6"></td>
								</tr>
							</table>
						</fieldset>
						<fieldset>
							<legend>问题整改</legend>
							<table border="0" cellpadding="0" cellspacing="0" class="tab_line_height" width="100%">
								<tr>
									<td class="inquire_item6">整改内容：</td>
									<td class="inquire_form6" colspan="5">
										<textarea id="modification_content" name="modification_content" class="textarea" readonly="readonly"></textarea>
								    </td>
								</tr>
								<tr>
									<td class="inquire_item6">整改结果：</td>
									<td class="inquire_form6" colspan="5">
										<textarea id="modification_result" name="modification_result" class="textarea"></textarea>
								    </td>
								</tr>
								<tr>
									<td class="inquire_item6">整改人：</td>
									<td class="inquire_form6">
										<input type="text" name="modification_people" id="modification_people" class="input_width" />
									</td>
									<td class="inquire_item6">整改时间：</td>
									<td class="inquire_form6">
										<input type="text" name="modification_time" id="modification_time" class="input_width" readonly="readonly"/>
										<img src="<%=contextPath%>/images/calendar.gif" id="tributton1" width='16' height='16' style="cursor: hand;" onmouseover="calDateSelector(modification_time,tributton1);"/>
									</td>
									<td class="inquire_item6"></td>
									<td class="inquire_form6"></td>
								</tr>
							</table>
						</fieldset>
						<%
							} 
						%>
						<!-- 轻便钻机-->
						<% 
							if("2".equals(type)){ 
						%>
						<fieldset>
							<legend>日常检查项目</legend>
							<table border="0" cellpadding="0" cellspacing="0" class="tab_line_height" width="100%">
								<tr>
									<td class="inquire_item6"></td>
									<td class="inquire_form6"></td>
									<td class="inquire_item6"></td>
									<td class="inquire_form6"></td>
									<td class="inquire_item6">检查记录时间：</td>
									<td class="inquire_form6">
										<input type="text" name="inspectioin_time" id="inspectioin_time" class="input_width" readonly="readonly"/>
										<img src="<%=contextPath%>/images/calendar.gif" id="tributton2" width='16' height='16' style="cursor: hand;" onmouseover="calDateSelector(inspectioin_time,tributton2);"/>
									</td>
								</tr>
							</table>
							<table width="250%" border="0" cellspacing="0" cellpadding="0" class="tab_info" style="margin-top: 2px;">
								<tr>
									<td class="bt_info_odd">&nbsp;&nbsp;&nbsp;</td>
									<td class="bt_info_even">发动机部分</td>
									<td class="bt_info_odd">液压系统部分</td>
									<td class="bt_info_even">井架部分</td>
									<td class="bt_info_odd">相关工作</td>
								</tr>
								<tr>
									<td style="border-bottom: black solid 1px;" align="center">启动前</td>
									<td style="border-bottom: black solid 1px; padding-left: 10px;"
										align="left" valign="top">
										<%
											String sql = " select dl.superior_code_id,dl.coding_sort_id,dl.coding_code_id,dl.coding_name from comm_coding_sort_detail dl where dl.coding_sort_id = '5110000160' and dl.superior_code_id = '5110000160000000005' and dl.bsflag = '0' order by dl.coding_code_id ";
											List list = BeanFactory.getQueryJdbcDAO().queryRecords(sql);
											for (int i = 0; i < list.size(); i++) {
												Map map = (Map) list.get(i);
												String codingName = (String) map.get("codingName");
												String codingCodeId = (String) map.get("codingCodeId");
										%> 
										<input type="checkbox" id="zyk<%=codingCodeId%>" name="zyk" value="<%=codingCodeId%>" checked="checked" onclick="loadMCContent()" /> 
										<span id="szyk<%=codingCodeId%>"><%=codingName%></span><br/> 
										<%
	 										}
	 									%>
									</td>
									<td style="border-bottom: black solid 1px; padding-left: 10px;"
										align="left" valign="top">
										<%
											String sqlA = " select dl.superior_code_id,dl.coding_sort_id,dl.coding_code_id,dl.coding_name from comm_coding_sort_detail dl where dl.coding_sort_id = '5110000160' and dl.superior_code_id = '5110000160000000008' and dl.bsflag = '0' order by dl.coding_code_id ";
											List listA = BeanFactory.getQueryJdbcDAO().queryRecords(sqlA);
											for (int i = 0; i < listA.size(); i++) {
												Map map = (Map) listA.get(i);
												String codingName = (String) map.get("codingName");
												String codingCodeId = (String) map.get("codingCodeId");
										%> 
										<input type="checkbox" id="zyk<%=codingCodeId%>" name="zyk" value="<%=codingCodeId%>" checked="checked" onclick="loadMCContent()" /> 
										<span id="szyk<%=codingCodeId%>"><%=codingName%></span><br/> 
										<%
	 										}
	 									%>
									</td>
									<td style="border-bottom: black solid 1px; padding-left: 10px;"
										align="left" valign="top">
										<%
											String sqlB = " select dl.superior_code_id,dl.coding_sort_id,dl.coding_code_id,dl.coding_name from comm_coding_sort_detail dl where dl.coding_sort_id = '5110000160' and dl.superior_code_id = '5110000160000000011' and dl.bsflag = '0' order by dl.coding_code_id ";
											List listB = BeanFactory.getQueryJdbcDAO().queryRecords(sqlB);
											for (int i = 0; i < listB.size(); i++) {
												Map map = (Map) listB.get(i);
												String codingName = (String) map.get("codingName");
												String codingCodeId = (String) map.get("codingCodeId");
										%> 
										<input type="checkbox" id="zyk<%=codingCodeId%>" name="zyk" value="<%=codingCodeId%>" checked="checked" onclick="loadMCContent()"/> 
										<span id="szyk<%=codingCodeId%>"> <%=codingName%></span><br/> 
										<%
	 										}
	 									%>
									</td>
									<td style="border-bottom: black solid 1px; padding-left: 10px;"
										align="left" valign="top">
										<%
											String sqlC = " select dl.superior_code_id,dl.coding_sort_id,dl.coding_code_id,dl.coding_name from comm_coding_sort_detail dl where dl.coding_sort_id = '5110000160' and dl.superior_code_id = '5110000160000000014' and dl.bsflag = '0' order by dl.coding_code_id ";
											List listC = BeanFactory.getQueryJdbcDAO().queryRecords(sqlC);
											for (int i = 0; i < listC.size(); i++) {
												Map map = (Map) listC.get(i);
												String codingName = (String) map.get("codingName");
												String codingCodeId = (String) map.get("codingCodeId");
										%> 
										<input type="checkbox" id="zyk<%=codingCodeId%>" name="zyk" value="<%=codingCodeId%>" checked="checked" onclick="loadMCContent()"/> 
										<span id="szyk<%=codingCodeId%>"> <%=codingName%></span><br/> 
										<%
	 										}
	 									%>
									</td>
								</tr>
								<tr>
									<td style="border-bottom: black solid 1px;" align="center">启动后</td>
									<td style="border-bottom: black solid 1px; padding-left: 10px;"
										align="left" valign="top">
										<%
											String sqlE = " select dl.superior_code_id,dl.coding_sort_id,dl.coding_code_id,dl.coding_name from comm_coding_sort_detail dl where dl.coding_sort_id = '5110000160' and dl.superior_code_id = '5110000160000000006' and dl.bsflag = '0' order by dl.coding_code_id ";
											List listE = BeanFactory.getQueryJdbcDAO().queryRecords(sqlE);
											for (int i = 0; i < listE.size(); i++) {
												Map map = (Map) listE.get(i);
												String codingName = (String) map.get("codingName");
												String codingCodeId = (String) map.get("codingCodeId");
										%> 
										<input type="checkbox" id="zyk<%=codingCodeId%>" name="zyk" value="<%=codingCodeId%>" checked="checked" onclick="loadMCContent()"/> 
										<span id="szyk<%=codingCodeId%>"><%=codingName%></span><br/> 
										<%
	 										}
	 									%>
									</td>
									<td style="border-bottom: black solid 1px; padding-left: 10px;"
										align="left" valign="top">
										<%
											String sqlF = " select dl.superior_code_id,dl.coding_sort_id,dl.coding_code_id,dl.coding_name from comm_coding_sort_detail dl where dl.coding_sort_id = '5110000160' and dl.superior_code_id = '5110000160000000009' and dl.bsflag = '0' order by dl.coding_code_id  ";
											List listF = BeanFactory.getQueryJdbcDAO().queryRecords(sqlF);
											for (int i = 0; i < listF.size(); i++) {
												Map map = (Map) listF.get(i);
												String codingName = (String) map.get("codingName");
												String codingCodeId = (String) map.get("codingCodeId");
										%> 
										<input type="checkbox" id="zyk<%=codingCodeId%>" name="zyk" value="<%=codingCodeId%>" checked="checked" onclick="loadMCContent()"/> 
										<span id="szyk<%=codingCodeId%>"><%=codingName%></span><br/> 
										<%
	 										}
	 									%>
									</td>
									<td style="border-bottom: black solid 1px; padding-left: 10px;"
										align="left" valign="top">
										<%
											String sqlG = " select dl.superior_code_id,dl.coding_sort_id,dl.coding_code_id,dl.coding_name from comm_coding_sort_detail dl where dl.coding_sort_id = '5110000160' and dl.superior_code_id = '5110000160000000012' and dl.bsflag = '0' order by dl.coding_code_id  ";
											List listG = BeanFactory.getQueryJdbcDAO().queryRecords(sqlG);
											for (int i = 0; i < listG.size(); i++) {
												Map map = (Map) listG.get(i);
												String codingName = (String) map.get("codingName");
												String codingCodeId = (String) map.get("codingCodeId");
										%> 
										<input type="checkbox" id="zyk<%=codingCodeId%>" name="zyk" value="<%=codingCodeId%>" checked="checked" onclick="loadMCContent()"/> 
										<span id="szyk<%=codingCodeId%>"> <%=codingName%></span><br/> 
										<%
	 										}
	 									%>
									</td>
									<td style="border-bottom: black solid 1px; padding-left: 10px;"
										align="left" valign="top">
										<%
											String sqlH = " select dl.superior_code_id,dl.coding_sort_id,dl.coding_code_id,dl.coding_name  from comm_coding_sort_detail dl where dl.coding_sort_id = '5110000160' and dl.superior_code_id = '5110000160000000015' and dl.bsflag = '0' order by dl.coding_code_id  ";
											List listH = BeanFactory.getQueryJdbcDAO().queryRecords(sqlH);
											for (int i = 0; i < listH.size(); i++) {
												Map map = (Map) listH.get(i);
												String codingName = (String) map.get("codingName");
												String codingCodeId = (String) map.get("codingCodeId");
										%> 
										<input type="checkbox" id="zyk<%=codingCodeId%>" name="zyk" value="<%=codingCodeId%>" checked="checked" onclick="loadMCContent()"/> 
										<span id="szyk<%=codingCodeId%>"><%=codingName%></span><br/> 
										<%
	 										}
	 									%>
									</td>
								</tr>
								<tr>
									<td style="border-bottom: black solid 1px;" align="center">停机后</td>
									<td style="border-bottom: black solid 1px; padding-left: 10px;"
										align="left" valign="top">
										<%
											String sqlK = " select dl.superior_code_id,dl.coding_sort_id,dl.coding_code_id,dl.coding_name from comm_coding_sort_detail dl where dl.coding_sort_id = '5110000160' and dl.superior_code_id = '5110000160000000007' and dl.bsflag = '0' order by dl.coding_code_id  ";
											List listK = BeanFactory.getQueryJdbcDAO().queryRecords(sqlK);
											for (int i = 0; i < listK.size(); i++) {
												Map map = (Map) listK.get(i);
												String codingName = (String) map.get("codingName");
												String codingCodeId = (String) map.get("codingCodeId");
										%> 
										<input type="checkbox" id="zyk<%=codingCodeId%>" name="zyk" value="<%=codingCodeId%>" checked="checked" onclick="loadMCContent()"/> 
										<span id="szyk<%=codingCodeId%>"><%=codingName%></span><br/> 
										<%
	 										}
	 									%>
									</td>
									<td style="border-bottom: black solid 1px; padding-left: 10px;"
										align="left" valign="top">
										<%
											String sqlL = " select dl.superior_code_id,dl.coding_sort_id,dl.coding_code_id,dl.coding_name from comm_coding_sort_detail dl where dl.coding_sort_id = '5110000160' and dl.superior_code_id = '5110000160000000010' and dl.bsflag = '0' order by dl.coding_code_id  ";
											List listL = BeanFactory.getQueryJdbcDAO().queryRecords(sqlL);
											for (int i = 0; i < listL.size(); i++) {
												Map map = (Map) listL.get(i);
												String codingName = (String) map.get("codingName");
												String codingCodeId = (String) map.get("codingCodeId");
										%> 
										<input type="checkbox" id="zyk<%=codingCodeId%>" name="zyk" value="<%=codingCodeId%>" checked="checked" onclick="loadMCContent()"/> 
										<span id="szyk<%=codingCodeId%>"><%=codingName%></span><br/> 
										<%
	 										}
	 									%>
									</td>
									<td style="border-bottom: black solid 1px; padding-left: 10px;"
										align="left" valign="top">
										<%
											String sqlM = " select dl.superior_code_id,dl.coding_sort_id,dl.coding_code_id,dl.coding_name from comm_coding_sort_detail dl where dl.coding_sort_id = '5110000160' and dl.superior_code_id = '5110000160000000013' and dl.bsflag = '0' order by dl.coding_code_id  ";
											List listM = BeanFactory.getQueryJdbcDAO().queryRecords(sqlM);
											for (int i = 0; i < listM.size(); i++) {
												Map map = (Map) listM.get(i);
												String codingName = (String) map.get("codingName");
												String codingCodeId = (String) map.get("codingCodeId");
										%> 
										<input type="checkbox" id="zyk<%=codingCodeId%>" name="zyk" value="<%=codingCodeId%>" checked="checked" onclick="loadMCContent()"/>
										<span id="szyk<%=codingCodeId%>"><%=codingName%></span><br/> 
										<%
	 										}
	 									%>
									</td>
									<td style="border-bottom: black solid 1px; padding-left: 10px;"
										align="left" valign="top">
										<%
											String sqlN = " select dl.superior_code_id,dl.coding_sort_id,dl.coding_code_id,dl.coding_name from comm_coding_sort_detail dl where dl.coding_sort_id = '5110000160' and dl.superior_code_id = '5110000160000000016' and dl.bsflag = '0' order by dl.coding_code_id  ";
											List listN = BeanFactory.getQueryJdbcDAO().queryRecords(sqlN);
											for (int i = 0; i < listN.size(); i++) {
												Map map = (Map) listN.get(i);
												String codingName = (String) map.get("codingName");
												String codingCodeId = (String) map.get("codingCodeId");
										%> 
										<input type="checkbox" id="zyk<%=codingCodeId%>" name="zyk" value="<%=codingCodeId%>" checked="checked" onclick="loadMCContent()"/> 
										<span id="szyk<%=codingCodeId%>"><%=codingName%></span><br/> 
										<%
	 										}
	 									%>
									</td>
								</tr>
							</table>
						</fieldset>
						<fieldset>
							<legend>运转记录</legend>
							<table border="0" cellpadding="0" cellspacing="0" class="tab_line_height" width="100%">
								<tr>
									<td class="inquire_item6">钻井进尺(米)：</td>
									<td class="inquire_form6">
										<input type="text" name="drilling_num" id="drilling_num" class="input_width"/>
									</td>
									<td class="inquire_item6">工作小时(小时)：</td>
									<td class="inquire_form6">
										<input type="text" name="work_hour" id="work_hour" class="input_width"/>
									</td>
									<td class="inquire_item6"></td>
									<td class="inquire_form6"></td>
								</tr>
							</table>
						</fieldset>
						<fieldset>
							<legend>燃油记录</legend>
							<table border="0" cellpadding="0" cellspacing="0" class="tab_line_height" width="100%">
								<tr>
									<td class="inquire_item6">燃油加油量(升)：</td>
									<td class="inquire_form6">
										<input type="text" name="oil_num" id="oil_num" class="input_width"/>
									</td>
									<td class="inquire_item6"></td>
									<td class="inquire_form6"></td>
									<td class="inquire_item6"></td>
									<td class="inquire_form6"></td>
								</tr>
							</table>
						<fieldset>
							<legend>问题整改</legend>
							<table border="0" cellpadding="0" cellspacing="0" class="tab_line_height" width="100%">
								<tr>
									<td class="inquire_item6">整改内容：</td>
									<td class="inquire_form6" colspan="5">
										<textarea id="modification_content" name="modification_content" class="textarea" readonly="readonly"></textarea>
								    </td>
								</tr>
								<tr>
									<td class="inquire_item6">整改结果：</td>
									<td class="inquire_form6" colspan="5">
										<textarea id="modification_result" name="modification_result" class="textarea"></textarea>
								    </td>
								</tr>
								<tr>
									<td class="inquire_item6">整改人：</td>
									<td class="inquire_form6">
										<input type="text" name="modification_people" id="modification_people" class="input_width" />
									</td>
									<td class="inquire_item6">整改时间：</td>
									<td class="inquire_form6">
										<input type="text" name="modification_time" id="modification_time" class="input_width" readonly="readonly"/>
										<img src="<%=contextPath%>/images/calendar.gif" id="tributton1" width='16' height='16' style="cursor: hand;" onmouseover="calDateSelector(modification_time,tributton1);"/>
									</td>
									<td class="inquire_item6"></td>
									<td class="inquire_form6"></td>
								</tr>
							</table>
						</fieldset>
						<%
							}
						%>
						<!-- 运输车辆 -->
						<%
							if ("3".equals(type)) {
						%>
						<fieldset>
							<legend>日常检查项目</legend>
							<table border="0" cellpadding="0" cellspacing="0" class="tab_line_height" width="100%">
								<tr>
									<td class="inquire_item6"></td>
									<td class="inquire_form6"></td>
									<td class="inquire_item6"></td>
									<td class="inquire_form6"></td>
									<td class="inquire_item6">检查记录时间：</td>
									<td class="inquire_form6">
										<input type="text" name="inspectioin_time" id="inspectioin_time" class="input_width" readonly="readonly"/>
										<img src="<%=contextPath%>/images/calendar.gif" id="tributton2" width='16' height='16' style="cursor: hand;" onmouseover="calDateSelector(inspectioin_time,tributton2);"/>
									</td>
								</tr>
							</table>
							<table width="250%" border="0" cellspacing="0" cellpadding="0" class="tab_info" style="margin-top: 2px;">
								<tr>
									<td class="bt_info_odd">&nbsp;&nbsp;&nbsp;</td>
									<td class="bt_info_even">发动机部分</td>
									<td class="bt_info_odd">底盘部分</td>
									<td class="bt_info_even">相关工作</td>
									<td class="bt_info_odd">车载发电机部分</td>
									<td class="bt_info_even">车载吊车部分</td>
								</tr>
								<tr>
									<td style="border-bottom: black solid 1px;" align="center">启动前</td>
									<td style="border-bottom: black solid 1px; padding-left: 10px;" align="left" valign="top">
										<%
								 			String sql = " select dl.superior_code_id,dl.coding_sort_id,dl.coding_code_id,dl.coding_name from comm_coding_sort_detail dl where dl.coding_sort_id = '5110000162' and dl.superior_code_id = '5110000162000000006' and dl.bsflag = '0' order by dl.coding_code_id ";
								  			List list = BeanFactory.getQueryJdbcDAO().queryRecords(sql); 
											for (int i = 0; i < list.size(); i++) {
												Map map = (Map)list.get(i);
												String codingName = (String)map.get("codingName");
												String codingCodeId = (String)map.get("codingCodeId");
										%>
							  			<input type="checkbox" id="zyk<%=codingCodeId%>" name="zyk" value="<%=codingCodeId%>" checked="checked" onclick="loadMCContent()"/> 
							  			<span id="szyk<%=codingCodeId%>"><%=codingName%></span><br/>
					           			<%
					           				}
					           			%>
									</td>
									<td style="border-bottom: black solid 1px; padding-left: 10px;" align="left" valign="top">
					           			<%
							 				String sqlA = " select dl.superior_code_id,dl.coding_sort_id,dl.coding_code_id,dl.coding_name from comm_coding_sort_detail dl where dl.coding_sort_id = '5110000162' and dl.superior_code_id = '5110000162000000009' and dl.bsflag = '0' order by dl.coding_code_id ";
							  				List listA = BeanFactory.getQueryJdbcDAO().queryRecords(sqlA); 
											for (int i = 0; i < listA.size(); i++) {
												Map map = (Map)listA.get(i);
												String codingName = (String)map.get("codingName");
												String codingCodeId = (String)map.get("codingCodeId");
										%>
						  				<input type="checkbox" id="zyk<%=codingCodeId%>" name="zyk" value="<%=codingCodeId%>" checked="checked" onclick="loadMCContent()"/>  
						  				<span id="szyk<%=codingCodeId%>"><%=codingName%></span><br/>
				           				<%
				           					}
				           				%>
									</td>
									<td style="border-bottom: black solid 1px; padding-left: 10px;" align="left" valign="top">
										<%
							 				String sqlB = " select dl.superior_code_id,dl.coding_sort_id,dl.coding_code_id,dl.coding_name from comm_coding_sort_detail dl where dl.coding_sort_id = '5110000162' and dl.superior_code_id = '5110000162000000012' and dl.bsflag = '0' order by dl.coding_code_id ";
							  				List listB = BeanFactory.getQueryJdbcDAO().queryRecords(sqlB); 
								  			for (int i = 0; i < listB.size(); i++) {
												Map map = (Map)listB.get(i);
												String codingName = (String)map.get("codingName");
												String codingCodeId = (String)map.get("codingCodeId");
										%>
					  					<input type="checkbox" id="zyk<%=codingCodeId%>" name="zyk" value="<%=codingCodeId%>" checked="checked" onclick="loadMCContent()"/> 
					  					<span id="szyk<%=codingCodeId%>"><%=codingName%></span><br/>
							            <%
							           		}
							            %>
									</td>
									<td style="border-bottom: black solid 1px; padding-left: 10px;" align="left" valign="top">
										<%
							 				String sqlC = " select dl.superior_code_id,dl.coding_sort_id,dl.coding_code_id,dl.coding_name from comm_coding_sort_detail dl where dl.coding_sort_id = '5110000162' and dl.superior_code_id = '5110000162000000015' and dl.bsflag = '0' order by dl.coding_code_id ";
							 				List listC = BeanFactory.getQueryJdbcDAO().queryRecords(sqlC); 
								  			for (int i = 0; i < listC.size(); i++) {
												Map map = (Map)listC.get(i);
												String codingName = (String)map.get("codingName");
												String codingCodeId = (String)map.get("codingCodeId");
										%> 
										<input type="checkbox" id="zyk<%=codingCodeId%>" name="zyk" value="<%=codingCodeId%>" checked="checked" onclick="loadMCContent()" /> 
										<span id="szyk<%=codingCodeId%>"> <%=codingName%></span><br/> 
										<%
				           					}
				           				%>
									</td>
									<td style="border-bottom: black solid 1px; padding-left: 10px;"
										align="left" valign="top">
										<%
								 			String sqlD = " select dl.superior_code_id,dl.coding_sort_id,dl.coding_code_id,dl.coding_name from comm_coding_sort_detail dl where dl.coding_sort_id = '5110000162' and dl.superior_code_id = '5110000162000000018' and dl.bsflag = '0' order by dl.coding_code_id ";
								  			List listD = BeanFactory.getQueryJdbcDAO().queryRecords(sqlD); 
											for (int i = 0; i < listD.size(); i++) {
												Map map = (Map)listD.get(i);
												String codingName = (String)map.get("codingName");
												String codingCodeId = (String)map.get("codingCodeId");
										%> 
										<input type="checkbox" id="zyk<%=codingCodeId%>" name="zyk" value="<%=codingCodeId%>" checked="checked" onclick="loadMCContent()" /> 
										<span id="szyk<%=codingCodeId%>"><%=codingName%></span> <br/> 
										<%
				           					}
				           				%>
									</td>
								</tr>
								<tr>
									<td style="border-bottom: black solid 1px;" align="center">启动后</td>
									<td style="border-bottom: black solid 1px; padding-left: 10px;"
										align="left" valign="top">
										<%
								 			String sqlE = " select dl.superior_code_id,dl.coding_sort_id,dl.coding_code_id,dl.coding_name from comm_coding_sort_detail dl where dl.coding_sort_id = '5110000162' and dl.superior_code_id = '5110000162000000007' and dl.bsflag = '0' order by dl.coding_code_id ";
								  			List listE = BeanFactory.getQueryJdbcDAO().queryRecords(sqlE); 
											for (int i = 0; i < listE.size(); i++) {
												Map map = (Map)listE.get(i);
												String codingName = (String)map.get("codingName");
												String codingCodeId = (String)map.get("codingCodeId");
										%> 
										<input type="checkbox" id="zyk<%=codingCodeId%>" name="zyk" value="<%=codingCodeId%>" checked="checked" onclick="loadMCContent()" /> 
										<span id="szyk<%=codingCodeId%>"><%=codingName%></span> <br/> 
										<%
					           				}
					           			%>
									</td>
									<td style="border-bottom: black solid 1px; padding-left: 10px;"
										align="left" valign="top">
										<%
								 			String sqlF = " select dl.superior_code_id,dl.coding_sort_id,dl.coding_code_id,dl.coding_name from comm_coding_sort_detail dl where dl.coding_sort_id = '5110000162' and dl.superior_code_id = '5110000162000000010' and dl.bsflag = '0' order by dl.coding_code_id  ";
								  			List listF = BeanFactory.getQueryJdbcDAO().queryRecords(sqlF); 
								  			for (int i = 0; i < listF.size(); i++) {
												Map map = (Map)listF.get(i);
												String codingName = (String)map.get("codingName");
												String codingCodeId = (String)map.get("codingCodeId");
										%> 
										<input type="checkbox" id="zyk<%=codingCodeId%>" name="zyk" value="<%=codingCodeId%>" checked="checked" onclick="loadMCContent()" /> 
										<span id="szyk<%=codingCodeId%>"><%=codingName%></span> <br/> 
										<%
					           				}
					           			%>
									</td>
									<td style="border-bottom: black solid 1px; padding-left: 10px;"
										align="left" valign="top">
										<%
							 				String sqlG = " select dl.superior_code_id,dl.coding_sort_id,dl.coding_code_id,dl.coding_name from comm_coding_sort_detail dl where dl.coding_sort_id = '5110000162' and dl.superior_code_id = '5110000162000000013' and dl.bsflag = '0' order by dl.coding_code_id  ";
							  				List listG = BeanFactory.getQueryJdbcDAO().queryRecords(sqlG); 
								  			for (int i = 0; i < listG.size(); i++) {
												Map map = (Map)listG.get(i);
												String codingName = (String)map.get("codingName");
												String codingCodeId = (String)map.get("codingCodeId");
										%> 
										<input type="checkbox" id="zyk<%=codingCodeId%>" name="zyk" value="<%=codingCodeId%>" checked="checked" onclick="loadMCContent()" /> 
										<span id="szyk<%=codingCodeId%>"><%=codingName%></span><br/> 
										<%
				           					}
				           				%>
									</td>
									<td style="border-bottom: black solid 1px; padding-left: 10px;"
										align="left" valign="top">
										<%
							 				String sqlH = " select dl.superior_code_id,dl.coding_sort_id,dl.coding_code_id,dl.coding_name from comm_coding_sort_detail dl where dl.coding_sort_id = '5110000162' and dl.superior_code_id = '5110000162000000016' and dl.bsflag = '0' order by dl.coding_code_id  ";
										  	List listH = BeanFactory.getQueryJdbcDAO().queryRecords(sqlH); 
										  	for (int i = 0; i < listH.size(); i++) {
												Map map = (Map)listH.get(i);
												String codingName = (String)map.get("codingName");
												String codingCodeId = (String)map.get("codingCodeId");
										%> 
										<input type="checkbox" id="zyk<%=codingCodeId%>" name="zyk" value="<%=codingCodeId%>" checked="checked" onclick="loadMCContent()" /> 
										<span id="szyk<%=codingCodeId%>"><%=codingName%></span> <br/> 
										<%
				           					}
				           				%>
									</td>
									<td style="border-bottom: black solid 1px; padding-left: 10px;"
										align="left" valign="top">
										<%
							 				String sqlJ = " select dl.superior_code_id,dl.coding_sort_id,dl.coding_code_id,dl.coding_name from comm_coding_sort_detail dl where dl.coding_sort_id = '5110000162' and dl.superior_code_id = '5110000162000000019' and dl.bsflag = '0' order by dl.coding_code_id  ";
							  				List listJ = BeanFactory.getQueryJdbcDAO().queryRecords(sqlJ); 
							  				for (int i = 0; i < listJ.size(); i++) {
												Map map = (Map)listJ.get(i);
												String codingName = (String)map.get("codingName");
												String codingCodeId = (String)map.get("codingCodeId");
										%> 
										<input type="checkbox" id="zyk<%=codingCodeId%>" name="zyk" value="<%=codingCodeId%>" checked="checked" onclick="loadMCContent()" /> 
										<span id="szyk<%=codingCodeId%>"><%=codingName%></span><br/> 
										<%
				           					}
				           				%>
									</td>
								</tr>
								<tr>
									<td style="border-bottom: black solid 1px;" align="center">停机后</td>
									<td style="border-bottom: black solid 1px; padding-left: 10px;"
										align="left" valign="top">
										<%
								 			String sqlK = " select dl.superior_code_id,dl.coding_sort_id,dl.coding_code_id,dl.coding_name from comm_coding_sort_detail dl where dl.coding_sort_id = '5110000162' and dl.superior_code_id = '5110000162000000008' and dl.bsflag = '0' order by dl.coding_code_id  ";
								  			List listK = BeanFactory.getQueryJdbcDAO().queryRecords(sqlK); 
								  			for (int i = 0; i < listK.size(); i++) {
												Map map = (Map)listK.get(i);
												String codingName = (String)map.get("codingName");
												String codingCodeId = (String)map.get("codingCodeId");
										%> 
										<input type="checkbox" id="zyk<%=codingCodeId%>" name="zyk" value="<%=codingCodeId%>" checked="checked" onclick="loadMCContent()" /> 
										<span id="szyk<%=codingCodeId%>"><%=codingName%></span><br/> 
										<%
					           				}
					           			%>
									</td>
									<td style="border-bottom: black solid 1px; padding-left: 10px;"
										align="left" valign="top">
										<%
								 			String sqlL = " select dl.superior_code_id,dl.coding_sort_id,dl.coding_code_id,dl.coding_name from comm_coding_sort_detail dl where dl.coding_sort_id = '5110000162' and dl.superior_code_id = '5110000162000000011' and dl.bsflag = '0' order by dl.coding_code_id  ";
								  			List listL = BeanFactory.getQueryJdbcDAO().queryRecords(sqlL); 
								  			for (int i = 0; i < listL.size(); i++) {
												Map map = (Map)listL.get(i);
												String codingName = (String)map.get("codingName");
												String codingCodeId = (String)map.get("codingCodeId");
										%> 
										<input type="checkbox" id="zyk<%=codingCodeId%>" name="zyk" value="<%=codingCodeId%>" checked="checked" onclick="loadMCContent()" /> 
										<span id="szyk<%=codingCodeId%>"><%=codingName%></span><br/> 
										<%
					           				}
					           			%>
									</td>
									<td style="border-bottom: black solid 1px; padding-left: 10px;"
										align="left" valign="top">
										<%
							 				String sqlM = " select dl.superior_code_id,dl.coding_sort_id,dl.coding_code_id,dl.coding_name from comm_coding_sort_detail dl where dl.coding_sort_id = '5110000162' and dl.superior_code_id = '5110000162000000014' and dl.bsflag = '0' order by dl.coding_code_id  ";
							  				List listM = BeanFactory.getQueryJdbcDAO().queryRecords(sqlM); 
							  				for (int i = 0; i < listM.size(); i++) {
												Map map = (Map)listM.get(i);
												String codingName = (String)map.get("codingName");
												String codingCodeId = (String)map.get("codingCodeId");
										%> 
										<input type="checkbox" id="zyk<%=codingCodeId%>" name="zyk" value="<%=codingCodeId%>" checked="checked" onclick="loadMCContent()" />
										<span id="szyk<%=codingCodeId%>"><%=codingName%></span><br/> 
										<%
				           					}
				           				%>
									</td>
									<td style="border-bottom: black solid 1px; padding-left: 10px;"
										align="left" valign="top">
										<%
											String sqlN = " select dl.superior_code_id,dl.coding_sort_id,dl.coding_code_id,dl.coding_name from comm_coding_sort_detail dl where dl.coding_sort_id = '5110000162' and dl.superior_code_id = '5110000162000000017' and dl.bsflag = '0' order by dl.coding_code_id  ";
											List listN = BeanFactory.getQueryJdbcDAO().queryRecords(sqlN);
											for (int i = 0; i < listN.size(); i++) {
												Map map = (Map) listN.get(i);
												String codingName = (String) map.get("codingName");
												String codingCodeId = (String) map.get("codingCodeId");
										%> 
										<input type="checkbox" id="zyk<%=codingCodeId%>" name="zyk" value="<%=codingCodeId%>" checked="checked" onclick="loadMCContent()" /> 
										<span id="szyk<%=codingCodeId%>"><%=codingName%></span><br/> 
										<%
				           					}
				           				%>
									</td>
									<td style="border-bottom: black solid 1px; padding-left: 10px;"
										align="left" valign="top">
										<%
							 				String sqlO = " select dl.superior_code_id,dl.coding_sort_id,dl.coding_code_id,dl.coding_name from comm_coding_sort_detail dl where dl.coding_sort_id = '5110000162' and dl.superior_code_id = '5110000162000000020' and dl.bsflag = '0' order by dl.coding_code_id  ";
							  				List listO = BeanFactory.getQueryJdbcDAO().queryRecords(sqlO); 
							  				for (int i = 0; i < listO.size(); i++) {
												Map map = (Map)listO.get(i);
												String codingName = (String)map.get("codingName");
												String codingCodeId = (String)map.get("codingCodeId");
										%> 
										<input type="checkbox" id="zyk<%=codingCodeId%>" name="zyk" value="<%=codingCodeId%>" checked="checked" onclick="loadMCContent()" /> 
										<span id="szyk<%=codingCodeId%>"><%=codingName%></span><br/> 
										<%
				           				    }
				           				%>
									</td>
								</tr>
							</table>
						</fieldset>
						<fieldset>
							<legend>运转记录</legend>
							<table border="0" cellpadding="0" cellspacing="0" class="tab_line_height" width="100%">
								<tr>
									<td class="inquire_item6">当日里程(公里)：</td>
									<td class="inquire_form6">
										<input type="text" name="mileage_today" id="mileage_today" class="input_width" />
									</td>
									<td class="inquire_item6">里程表读数(公里)：</td>
									<td class="inquire_form6">
										<input type="text" name="mileage_write" id="mileage_write" class="input_width" />
									</td>
									<td class="inquire_item6"></td>
									<td class="inquire_form6"></td>
								</tr>
							</table>
						</fieldset>
						<fieldset>
							<legend>燃油记录</legend>
							<table border="0" cellpadding="0" cellspacing="0" class="tab_line_height" width="100%">
								<tr>
									<td class="inquire_item6">燃油加油量(升)：</td>
									<td class="inquire_form6">
										<input type="text" name="oil_num" id="oil_num" class="input_width" />
									</td>
									<td class="inquire_item6"></td>
									<td class="inquire_form6"></td>
									<td class="inquire_item6"></td>
									<td class="inquire_form6"></td>
								</tr>
							</table>
						</fieldset>
						<fieldset>
							<legend>问题整改</legend>
							<table border="0" cellpadding="0" cellspacing="0" class="tab_line_height" width="100%">
								<tr>
									<td class="inquire_item6">整改内容：</td>
									<td class="inquire_form6" colspan="5">
										<textarea id="modification_content" name="modification_content" class="textarea" readonly="readonly"></textarea>
								    </td>
								</tr>
								<tr>
									<td class="inquire_item6">整改结果：</td>
									<td class="inquire_form6" colspan="5">
										<textarea id="modification_result" name="modification_result" class="textarea"></textarea>
								    </td>
								</tr>
								<tr>
									<td class="inquire_item6">整改人：</td>
									<td class="inquire_form6">
										<input type="text" name="modification_people" id="modification_people" class="input_width" />
									</td>
									<td class="inquire_item6">整改时间：</td>
									<td class="inquire_form6">
										<input type="text" name="modification_time" id="modification_time" class="input_width" readonly="readonly"/>
										<img src="<%=contextPath%>/images/calendar.gif" id="tributton1" width='16' height='16' style="cursor: hand;" onmouseover="calDateSelector(modification_time,tributton1);"/>
									</td>
									<td class="inquire_item6"></td>
									<td class="inquire_form6"></td>
								</tr>
							</table>
						</fieldset>
						<%
							} 
						%>
						<!-- 车装钻机-->
						<% 
							if("4".equals(type)){ 
						%>
						<fieldset>
							<legend>日常检查项目</legend>
							<table border="0" cellpadding="0" cellspacing="0" class="tab_line_height" width="100%">
								<tr>
									<td class="inquire_item6"></td>
									<td class="inquire_form6"></td>
									<td class="inquire_item6"></td>
									<td class="inquire_form6"></td>
									<td class="inquire_item6">检查记录时间：</td>
									<td class="inquire_form6">
										<input type="text" name="inspectioin_time" id="inspectioin_time" class="input_width" readonly="readonly"/>
										<img src="<%=contextPath%>/images/calendar.gif" id="tributton2" width='16' height='16' style="cursor: hand;" onmouseover="calDateSelector(inspectioin_time,tributton2);"/>
									</td>
								</tr>
							</table>
							<table width="250%" border="0" cellspacing="0" cellpadding="0" class="tab_info" style="margin-top: 2px;">
								<tr>
									<td class="bt_info_odd">&nbsp;&nbsp;&nbsp;</td>
									<td class="bt_info_even">传动部分</td>
									<td class="bt_info_odd">井架部分</td>
									<td class="bt_info_even">相关工作</td>
								</tr>
								<tr>
									<td style="border-bottom: black solid 1px;" align="center">启动前</td>
									<td style="border-bottom: black solid 1px; padding-left: 10px;"
										align="left" valign="top">
										<%
											String sql = " select dl.superior_code_id,dl.coding_sort_id,dl.coding_code_id,dl.coding_name from comm_coding_sort_detail dl where dl.coding_sort_id = '5110000163' and dl.superior_code_id = '5110000163000000004' and dl.bsflag = '0' order by dl.coding_code_id ";
											List list = BeanFactory.getQueryJdbcDAO().queryRecords(sql);
											for (int i = 0; i < list.size(); i++) {
												Map map = (Map) list.get(i);
												String codingName = (String) map.get("codingName");
												String codingCodeId = (String) map.get("codingCodeId");
										%> 
										<input type="checkbox" id="zyk<%=codingCodeId%>" name="zyk" value="<%=codingCodeId%>" checked="checked" onclick="loadMCContent()"/> 
										<span id="szyk<%=codingCodeId%>"><%=codingName%></span><br/> 
										<%
	 										}
	 									%>
									</td>
									<td style="border-bottom: black solid 1px; padding-left: 10px;"
										align="left" valign="top">
										<%
											String sqlA = " select dl.superior_code_id,dl.coding_sort_id,dl.coding_code_id,dl.coding_name from comm_coding_sort_detail dl where dl.coding_sort_id = '5110000163' and dl.superior_code_id = '5110000163000000007' and dl.bsflag = '0' order by dl.coding_code_id ";
											List listA = BeanFactory.getQueryJdbcDAO().queryRecords(sqlA);
											for (int i = 0; i < listA.size(); i++) {
												Map map = (Map) listA.get(i);
												String codingName = (String) map.get("codingName");
												String codingCodeId = (String) map.get("codingCodeId");
										%> 
										<input type="checkbox" id="zyk<%=codingCodeId%>" name="zyk" value="<%=codingCodeId%>" checked="checked" onclick="loadMCContent()"/> 
										<span id="szyk<%=codingCodeId%>"><%=codingName%></span><br/> 
										<%
	 										}
	 									%>
									</td>
									<td style="border-bottom: black solid 1px; padding-left: 10px;"
										align="left" valign="top">
										<%
											String sqlB = " select dl.superior_code_id,dl.coding_sort_id,dl.coding_code_id,dl.coding_name from comm_coding_sort_detail dl where dl.coding_sort_id = '5110000163' and dl.superior_code_id = '5110000163000000010' and dl.bsflag = '0' order by dl.coding_code_id ";
											List listB = BeanFactory.getQueryJdbcDAO().queryRecords(sqlB);
											for (int i = 0; i < listB.size(); i++) {
												Map map = (Map) listB.get(i);
												String codingName = (String) map.get("codingName");
												String codingCodeId = (String) map.get("codingCodeId");
										%> 
										<input type="checkbox" id="zyk<%=codingCodeId%>" name="zyk" value="<%=codingCodeId%>" checked="checked" onclick="loadMCContent()"/> 
										<span id="szyk<%=codingCodeId%>"><%=codingName%></span><br/> 
										<%
	 										}
	 									%>
									</td>
								</tr>
								<tr>
									<td style="border-bottom: black solid 1px;" align="center">启动后</td>
									<td style="border-bottom: black solid 1px; padding-left: 10px;"
										align="left" valign="top">
										<%
											String sqlE = " select dl.superior_code_id,dl.coding_sort_id,dl.coding_code_id,dl.coding_name from comm_coding_sort_detail dl where dl.coding_sort_id = '5110000163' and dl.superior_code_id = '5110000163000000005' and dl.bsflag = '0' order by dl.coding_code_id ";
											List listE = BeanFactory.getQueryJdbcDAO().queryRecords(sqlE);
											for (int i = 0; i < listE.size(); i++) {
												Map map = (Map) listE.get(i);
												String codingName = (String) map.get("codingName");
												String codingCodeId = (String) map.get("codingCodeId");
										%> 
										<input type="checkbox" id="zyk<%=codingCodeId%>" name="zyk" value="<%=codingCodeId%>" checked="checked" onclick="loadMCContent()"/> 
										<span id="szyk<%=codingCodeId%>"><%=codingName%></span><br/> 
										<%
	 										}
	 									%>
									</td>
									<td style="border-bottom: black solid 1px; padding-left: 10px;"
										align="left" valign="top">
										<%
											String sqlF = " select dl.superior_code_id,dl.coding_sort_id,dl.coding_code_id,dl.coding_name from comm_coding_sort_detail dl where dl.coding_sort_id = '5110000163' and dl.superior_code_id = '5110000163000000008' and dl.bsflag = '0' order by dl.coding_code_id  ";
											List listF = BeanFactory.getQueryJdbcDAO().queryRecords(sqlF);
											for (int i = 0; i < listF.size(); i++) {
												Map map = (Map) listF.get(i);
												String codingName = (String) map.get("codingName");
												String codingCodeId = (String) map.get("codingCodeId");
										%> 
										<input type="checkbox" id="zyk<%=codingCodeId%>" name="zyk" value="<%=codingCodeId%>" checked="checked" onclick="loadMCContent()"/> 
										<span id="szyk<%=codingCodeId%>"><%=codingName%></span><br/> 
										<%
	 										}
	 									%>
									</td>
									<td style="border-bottom: black solid 1px; padding-left: 10px;"
										align="left" valign="top">
										<%
											String sqlG = " select dl.superior_code_id,dl.coding_sort_id,dl.coding_code_id,dl.coding_name from comm_coding_sort_detail dl where dl.coding_sort_id = '5110000163' and dl.superior_code_id = '5110000163000000011' and dl.bsflag = '0' order by dl.coding_code_id  ";
											List listG = BeanFactory.getQueryJdbcDAO().queryRecords(sqlG);
											for (int i = 0; i < listG.size(); i++) {
												Map map = (Map) listG.get(i);
												String codingName = (String) map.get("codingName");
												String codingCodeId = (String) map.get("codingCodeId");
										%> 
										<input type="checkbox" id="zyk<%=codingCodeId%>" name="zyk" value="<%=codingCodeId%>" checked="checked" onclick="loadMCContent()"/> 
										<span id="szyk<%=codingCodeId%>"><%=codingName%></span><br/> 
										<%
	 										}
	 									%>
									</td>
								</tr>
								<tr>
									<td style="border-bottom: black solid 1px;" align="center">停机后</td>
									<td style="border-bottom: black solid 1px; padding-left: 10px;"
										align="left" valign="top">
										<%
											String sqlK = " select dl.superior_code_id,dl.coding_sort_id,dl.coding_code_id,dl.coding_name from comm_coding_sort_detail dl where dl.coding_sort_id = '5110000163' and dl.superior_code_id = '5110000163000000006' and dl.bsflag = '0' order by dl.coding_code_id  ";
											List listK = BeanFactory.getQueryJdbcDAO().queryRecords(sqlK);
											for (int i = 0; i < listK.size(); i++) {
												Map map = (Map) listK.get(i);
												String codingName = (String) map.get("codingName");
												String codingCodeId = (String) map.get("codingCodeId");
										%> 
										<input type="checkbox" id="zyk<%=codingCodeId%>" name="zyk" value="<%=codingCodeId%>" checked="checked" onclick="loadMCContent()"/> 
										<span id="szyk<%=codingCodeId%>"><%=codingName%></span><br/> 
										<%
	 										}
	 									%>
									</td>
									<td style="border-bottom: black solid 1px; padding-left: 10px;"
										align="left" valign="top">
										<%
											String sqlL = " select dl.superior_code_id,dl.coding_sort_id,dl.coding_code_id,dl.coding_name from comm_coding_sort_detail dl where dl.coding_sort_id = '5110000163' and dl.superior_code_id = '5110000163000000009' and dl.bsflag = '0' order by dl.coding_code_id  ";
											List listL = BeanFactory.getQueryJdbcDAO().queryRecords(sqlL);
											for (int i = 0; i < listL.size(); i++) {
												Map map = (Map) listL.get(i);
												String codingName = (String) map.get("codingName");
												String codingCodeId = (String) map.get("codingCodeId");
										%> 
										<input type="checkbox" id="zyk<%=codingCodeId%>" name="zyk" value="<%=codingCodeId%>" checked="checked" onclick="loadMCContent()"/> 
										<span id="szyk<%=codingCodeId%>"><%=codingName%></span><br/> 
										<%
	 										}
	 									%>
									</td>
									<td style="border-bottom: black solid 1px; padding-left: 10px;"
										align="left" valign="top">
										<%
											String sqlM = " select dl.superior_code_id,dl.coding_sort_id,dl.coding_code_id,dl.coding_name from comm_coding_sort_detail dl where dl.coding_sort_id = '5110000163' and dl.superior_code_id = '5110000163000000012' and dl.bsflag = '0' order by dl.coding_code_id  ";
											List listM = BeanFactory.getQueryJdbcDAO().queryRecords(sqlM);
											for (int i = 0; i < listM.size(); i++) {
												Map map = (Map) listM.get(i);
												String codingName = (String) map.get("codingName");
												String codingCodeId = (String) map.get("codingCodeId");
										%> 
										<input type="checkbox" id="zyk<%=codingCodeId%>" name="zyk" value="<%=codingCodeId%>" checked="checked" onclick="loadMCContent()"/>
										<span id="szyk<%=codingCodeId%>"><%=codingName%></span><br/> 
										<%
	 										}
	 									%>
									</td>
								</tr>
							</table>
						</fieldset>
						<fieldset>
							<legend>运转记录</legend>
							<table border="0" cellpadding="0" cellspacing="0" class="tab_line_height" width="100%">
								<tr>
									<td class="inquire_item6">钻井进尺(米)：</td>
									<td class="inquire_form6">
										<input type="text" name="drilling_num" id="drilling_num" class="input_width" />
									</td>
									<td class="inquire_item6">工作小时(小时)：</td>
									<td class="inquire_form6">
										<input type="text" name="work_hour" id="work_hour" class="input_width" />
									</td>
									<td class="inquire_item6"></td>
									<td class="inquire_form6"></td>
								</tr>
							</table>
						</fieldset>
						<fieldset>
							<legend>问题整改</legend>
							<table border="0" cellpadding="0" cellspacing="0" class="tab_line_height" width="100%">
								<tr>
									<td class="inquire_item6">整改内容：</td>
									<td class="inquire_form6" colspan="5">
										<textarea id="modification_content" name="modification_content" class="textarea" readonly="readonly"></textarea>
								    </td>
								</tr>
								<tr>
									<td class="inquire_item6">整改结果：</td>
									<td class="inquire_form6" colspan="5">
										<textarea id="modification_result" name="modification_result" class="textarea"></textarea>
								    </td>
								</tr>
								<tr>
									<td class="inquire_item6">整改人：</td>
									<td class="inquire_form6">
										<input type="text" name="modification_people" id="modification_people" class="input_width" />
									</td>
									<td class="inquire_item6">整改时间：</td>
									<td class="inquire_form6">
										<input type="text" name="modification_time" id="modification_time" class="input_width" readonly="readonly"/>
										<img src="<%=contextPath%>/images/calendar.gif" id="tributton1" width='16' height='16' style="cursor: hand;" onmouseover="calDateSelector(modification_time,tributton1);"/>
									</td>
									<td class="inquire_item6"></td>
									<td class="inquire_form6"></td>
								</tr>
							</table>
						</fieldset>
						<%
							}
						%>
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
	 	var devinspectioin_id='<%=devinspectioin_id%>';
	 	var flag='<%=flag%>';
	 	var type='<%=type%>';
	 	
	 	$(function(){
			if("update"==flag){
		 		if(""!=devinspectioin_id){	
		 			var uQuerySql = "select t.*,m.inspectioin_item_code,acc.dev_name,acc.dev_model,acc.self_num,acc.dev_sign,acc.license_num from gms_device_inspectioin t "+
					" left join gms_device_inspectioin_item m on t.devinspectioin_id = m.devinspectioin_id and m.bsflag = '0' "+
					" left join gms_device_account acc on t.dev_acc_id = acc.dev_acc_id and acc.bsflag = '0' "+
					" where t.bsflag = '0' and t.devinspectioin_id = '"+devinspectioin_id+"'";				 	 
					var uQueryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'pageSize=100000&querySql='+encodeURI(encodeURI(uQuerySql)));
					var uDatas = uQueryRet.datas;
					if(uDatas != null&&uDatas!=""){
						document.getElementById("devinspectioin_id").value = uDatas[0].devinspectioin_id;
						document.getElementById("dev_acc_id").value = uDatas[0].dev_acc_id;
						document.getElementById("dev_name").value = uDatas[0].dev_name;
						document.getElementById("dev_model").value = uDatas[0].dev_model;
						document.getElementById("self_num").value = uDatas[0].self_num;
						document.getElementById("dev_sign").value = uDatas[0].dev_sign;
						document.getElementById("license_num").value = uDatas[0].license_num;
						document.getElementById("type").value = uDatas[0].type;
						if("1"==type){
							document.getElementById("oil_num").value = uDatas[0].oil_num;
						}
						if("2"==type){
							document.getElementById("oil_num").value = uDatas[0].oil_num;
							document.getElementById("drilling_num").value = uDatas[0].drilling_num;
							document.getElementById("work_hour").value = uDatas[0].work_hour;					
						}
						if("3"==type){
							document.getElementById("mileage_today").value = uDatas[0].mileage_today;
							document.getElementById("mileage_write").value = uDatas[0].mileage_write;
							document.getElementById("oil_num").value = uDatas[0].oil_num;
						}
						if("4"==type){
							document.getElementById("drilling_num").value = uDatas[0].drilling_num;
							document.getElementById("work_hour").value = uDatas[0].work_hour;
						}
						document.getElementById("modification_result").value = uDatas[0].modification_result;
						document.getElementById("modification_people").value = uDatas[0].modification_people;
						document.getElementById("modification_time").value = uDatas[0].modification_time;
						document.getElementById("modification_content").value = uDatas[0].modification_content;
						document.getElementById("inspectioin_time").value = uDatas[0].inspectioin_time;
						var zyk = document.getElementsByName("zyk");
						for(var j=0;j<zyk.length;j++){
							for(var i=0;i<uDatas.length;i++){
								if(zyk[j].value == uDatas[i].inspectioin_item_code){	
						 			zyk[j].checked=false;
								}	 
						 	}
						}
					}	
				}
		 	}
		});

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

	</script>
</html>
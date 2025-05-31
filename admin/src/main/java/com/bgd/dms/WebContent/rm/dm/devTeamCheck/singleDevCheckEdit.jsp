<%@ page contentType="text/html;charset=UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%@ taglib uri="code" prefix="code"%> 
<%
	String contextPath = request.getContextPath();
	//设备检查id
	String inspectionTeamId=request.getParameter("inspectionTeamId");
	//设备台账id
	String devAccId=request.getParameter("devAccId");
	//设备编码
	String devType=request.getParameter("devType");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" /> 
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open1.js"></script>
  <title>设备检查</title> 
 </head>
<body style="background:#cdddef">
	<form name="form1" id="form1" method="post" enctype="multipart/form-data" action="">
		<!-- 主键 -->
		<input  type ="hidden" id="inspection_id" name="inspection_id" class="input_width" />
		<!-- 设备检查id -->
		<input  type ="hidden" id="inspection_team_id" name="inspection_team_id" class="input_width" />
		<!-- 检查人 -->
		<input  type ="hidden" id="inspector" name="inspector" class="input_width" />
		<!-- 项目id -->
		<input  type ="hidden" id="project_info_no" name="project_info_no" class="input_width" />
		<div id="new_table_box" >
  			<div id="new_table_box_content">
    			<div id="new_table_box_bg" >
				    <fieldset>
					  	<legend>基本信息</legend>
					  	<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
					  		<tr>
							  	<td class="inquire_item6">检查日期：</td>
								<td class="inquire_form6">
									<input id="inspection_date" name="inspection_date"  class="input_width" type="text" readonly/>
									<img src="<%=contextPath%>/images/calendar.gif" id="tributton1" width='16' height='16' style="cursor: hand;" onmouseover="calDateSelector(inspection_date,tributton1);"/>
								</td>
						  		<td class="inquire_item6">设备名称：</td>
								<td class="inquire_form6">
									<input id="dev_name" name="dev_name" class="input_width" type="text" readonly="readonly"/>
									<!-- 设备台账id -->
									<input  type ="hidden" id="device_account_id" name="device_account_id" class="input_width" />
									<!-- 设备编码 -->
									<input  type ="hidden" id="dev_type" name="dev_type" class="input_width" />
								</td>
							</tr>
						  	<tr>
						  		<td class="inquire_item6">规格型号：</td>
								<td class="inquire_form6">
									<input id="dev_model" name="dev_model" class="input_width" type="text" readonly="readonly"/>
								</td>
								<td class="inquire_item6"></td>
								<td class="inquire_form6"></td>
						  	</tr>
						  	<tr>
							  	<td class="inquire_item6">存在描述：</td>
								<td class="inquire_form6" colspan="3">
									<textarea rows="2" cols="59" id="inspection_content" name="inspection_content" class="textarea" style="height:50px"></textarea>
									<!-- 选中的检查项 -->
									<input  type ="hidden" id="checked_items" name="checked_items" class="input_width" />
								</td>
							 </tr>
					 	</table>
					</fieldset>
					<!-- 车装钻机检查 -->
					<% if(devType.startsWith("S060101")||devType.startsWith("S060199")){ %>
					<fieldset>
						<legend>检查项</legend>
						<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
							<tr>
								<td class="inquire_item6">泥浆泵及其附件：</td>
							    <td class="inquire_form6">
							     	<input name="check_item" id="5110000164000000020" type="checkbox" value="5110000164000000020" checked="checked"/>
							    </td>
							    <td class="inquire_item6">钻机井架及其附件：</td>
							    <td class="inquire_form6">
							     	<input name="check_item" id="5110000164000000021" type="checkbox" value="5110000164000000021" checked="checked"/>
							    </td>
							    <td class="inquire_item6">空压机、离合器及其附件：</td>
							    <td class="inquire_form6">
							     	<input name="check_item" id="5110000164000000022" type="checkbox" value="5110000164000000022" checked="checked"/>
							    </td>
							</tr>
							<tr>
							    <td class="inquire_item6">液压系统及其附件：</td>
							    <td class="inquire_form6">
							     	<input name="check_item" id="5110000164000000023" type="checkbox" value="5110000164000000023" checked="checked"/>
							    </td>
							    <td class="inquire_item6">操作阀、接头及手柄：</td>
							    <td class="inquire_form6">
							     	<input name="check_item" id="5110000164000000024" type="checkbox" value="5110000164000000024" checked="checked"/>
							    </td>
							    <td class="inquire_item6">取力器：</td>
							    <td class="inquire_form6">
							     	<input name="check_item" id="5110000164000000025" type="checkbox" value="5110000164000000025" checked="checked"/>
							    </td>
							</tr>
							<tr>
							    <td class="inquire_item6">减速箱：</td>
							    <td class="inquire_form6">
							     	<input name="check_item" id="5110000164000000026" type="checkbox" value="5110000164000000026" checked="checked"/>
							    </td>
							    <td class="inquire_item6">日常检查记录：</td>
							    <td class="inquire_form6">
							     	<input name="check_item" id="5110000164000000027" type="checkbox" value="5110000164000000027" checked="checked"/>
							    </td>
							    <td class="inquire_item6"></td>
							    <td class="inquire_form6"></td>
							</tr>
			        	</table>
					</fieldset>
					<% } %>
					<!-- 轻便钻机检查 -->
					<% if(devType.startsWith("S060102")){ %>
					<fieldset>
						<legend>发动机</legend>
						<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
							<tr>
								<td class="inquire_item6">启动性能：</td>
							    <td class="inquire_form6">
							     	<input name="check_item" id="5110000164000000032" type="checkbox" value="5110000164000000032" checked="checked"/>
							    </td>
							    <td class="inquire_item6">三滤：</td>
							    <td class="inquire_form6">
							     	<input name="check_item" id="5110000164000000033" type="checkbox" value="5110000164000000033" checked="checked"/>
							    </td>
							    <td class="inquire_item6">机油压力：</td>
							    <td class="inquire_form6">
							     	<input name="check_item" id="5110000164000000034" type="checkbox" value="5110000164000000034" checked="checked"/>
							    </td>
							</tr>
							<tr>
							    <td class="inquire_item6">皮带：</td>
							    <td class="inquire_form6">
							     	<input name="check_item" id="5110000164000000035" type="checkbox" value="5110000164000000035" checked="checked"/>
							    </td>
							    <td class="inquire_item6">冷却系统：</td>
							    <td class="inquire_form6">
							     	<input name="check_item" id="5110000164000000036" type="checkbox" value="5110000164000000036" checked="checked"/>
							    </td>
							    <td class="inquire_item6"></td>
							    <td class="inquire_form6"></td>
							</tr>
			        	</table>
			        </fieldset>
			        <fieldset>
						<legend>空压机</legend>
						<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
							<tr>
								<td class="inquire_item6">散热器：</td>
							    <td class="inquire_form6">
							     	<input name="check_item" id="5110000164000000037" type="checkbox" value="5110000164000000037" checked="checked"/>
							    </td>
							    <td class="inquire_item6">三滤：</td>
							    <td class="inquire_form6">
							     	<input name="check_item" id="5110000164000000038" type="checkbox" value="5110000164000000038" checked="checked"/>
							    </td>
							    <td class="inquire_item6">机油：</td>
							    <td class="inquire_form6">
							     	<input name="check_item" id="5110000164000000039" type="checkbox" value="5110000164000000039" checked="checked"/>
							    </td>
							</tr>
							<tr>
							    <td class="inquire_item6">皮带：</td>
							    <td class="inquire_form6">
							     	<input name="check_item" id="5110000164000000040" type="checkbox" value="5110000164000000040" checked="checked"/>
							    </td>
							    <td class="inquire_item6"></td>
							    <td class="inquire_form6"></td>
							    <td class="inquire_item6"></td>
							    <td class="inquire_form6"></td>
							</tr>
			        	</table>
			        </fieldset>
			        <fieldset>
						<legend>液压部分</legend>
						<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
							<tr>
								<td class="inquire_item6">液压泵：</td>
							    <td class="inquire_form6">
							     	<input name="check_item" id="5110000164000000041" type="checkbox" value="5110000164000000041" checked="checked"/>
							    </td>
							    <td class="inquire_item6">马达：</td>
							    <td class="inquire_form6">
							     	<input name="check_item" id="5110000164000000042" type="checkbox" value="5110000164000000042" checked="checked"/>
							    </td>
							    <td class="inquire_item6">操作台：</td>
							    <td class="inquire_form6">
							     	<input name="check_item" id="5110000164000000043" type="checkbox" value="5110000164000000043" checked="checked"/>
							    </td>
							</tr>
							<tr>
							    <td class="inquire_item6">散热器：</td>
							    <td class="inquire_form6">
							     	<input name="check_item" id="5110000164000000044" type="checkbox" value="5110000164000000044" checked="checked"/>
							    </td>
							    <td class="inquire_item6">管线：</td>
							    <td class="inquire_form6">
							     	<input name="check_item" id="5110000164000000045" type="checkbox" value="5110000164000000045" checked="checked"/>
							    </td>
							    <td class="inquire_item6"></td>
							    <td class="inquire_form6"></td>
							</tr>
			        	</table>
			        </fieldset>
			        <fieldset>
						<legend>井架部分</legend>
						<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
							<tr>
								<td class="inquire_item6">动力头：</td>
							    <td class="inquire_form6">
							     	<input name="check_item" id="5110000164000000046" type="checkbox" value="5110000164000000046" checked="checked"/>
							    </td>
							    <td class="inquire_item6">链条：</td>
							    <td class="inquire_form6">
							     	<input name="check_item" id="5110000164000000047" type="checkbox" value="5110000164000000047" checked="checked"/>
							    </td>
							    <td class="inquire_item6">井架：</td>
							    <td class="inquire_form6">
							     	<input name="check_item" id="5110000164000000048" type="checkbox" value="5110000164000000048" checked="checked"/>
							    </td>
							</tr>
							<tr>
							    <td class="inquire_item6">底座：</td>
							    <td class="inquire_form6">
							     	<input name="check_item" id="5110000164000000049" type="checkbox" value="5110000164000000049" checked="checked"/>
							    </td>
							    <td class="inquire_item6"></td>
							    <td class="inquire_form6"></td>
							    <td class="inquire_item6"></td>
							    <td class="inquire_form6"></td>
							</tr>
			        	</table>
			        </fieldset>
			        <fieldset>
						<legend>仪表电器</legend>
						<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
							<tr>
							    <td class="inquire_item6">仪表电器：</td>
							    <td class="inquire_form6">
							     	<input name="check_item" id="5110000164000000050" type="checkbox" value="5110000164000000050" checked="checked"/>
							    </td>
							    <td class="inquire_item6"></td>
							    <td class="inquire_form6"></td>
							    <td class="inquire_item6"></td>
							    <td class="inquire_form6"></td>
							</tr>
			        	</table>
			        </fieldset>
			        <fieldset>
						<legend>日常检查记录</legend>
						<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
							<tr>
							    <td class="inquire_item6">日常检查记录：</td>
							    <td class="inquire_form6">
							     	<input name="check_item" id="5110000164000000051" type="checkbox" value="5110000164000000051" checked="checked"/>
							    </td>
							    <td class="inquire_item6"></td>
							    <td class="inquire_form6"></td>
							    <td class="inquire_item6"></td>
							    <td class="inquire_form6"></td>
							</tr>
			        	</table>
					</fieldset>
					<% } %>
					<!-- 推土机检查 -->
					<% if(devType.startsWith("S070301")){ %>
					<fieldset>
						<legend>发动机</legend>
						<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
							<tr>
								<td class="inquire_item6">启动性能：</td>
							    <td class="inquire_form6">
							     	<input name="check_item" id="5110000164000000053" type="checkbox" value="5110000164000000053" checked="checked"/>
							    </td>
							    <td class="inquire_item6">三滤：</td>
							    <td class="inquire_form6">
							     	<input name="check_item" id="5110000164000000054" type="checkbox" value="5110000164000000054" checked="checked"/>
							    </td>
							    <td class="inquire_item6">机油压力：</td>
							    <td class="inquire_form6">
							     	<input name="check_item" id="5110000164000000055" type="checkbox" value="5110000164000000055" checked="checked"/>
							    </td>
							</tr>
							<tr>
							    <td class="inquire_item6">各种皮带：</td>
							    <td class="inquire_form6">
							     	<input name="check_item" id="5110000164000000056" type="checkbox" value="5110000164000000056" checked="checked"/>
							    </td>
							    <td class="inquire_item6">冷却系统：</td>
							    <td class="inquire_form6">
							     	<input name="check_item" id="5110000164000000057" type="checkbox" value="5110000164000000057" checked="checked"/>
							    </td>
							    <td class="inquire_item6"></td>
							    <td class="inquire_form6"></td>
							</tr>
			        	</table>
					</fieldset>
					<fieldset>
						<legend>传动系统</legend>
						<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
							<tr>
							    <td class="inquire_item6">传动系统：</td>
							    <td class="inquire_form6">
							     	<input name="check_item" id="5110000164000000058" type="checkbox" value="5110000164000000058" checked="checked"/>
							    </td>
							    <td class="inquire_item6"></td>
							    <td class="inquire_form6"></td>
							    <td class="inquire_item6"></td>
							    <td class="inquire_form6"></td>
							</tr>
			        	</table>
					</fieldset>
					<fieldset>
						<legend>液压系统</legend>
						<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
							<tr>
								<td class="inquire_item6">液压系统：</td>
							    <td class="inquire_form6">
							     	<input name="check_item" id="5110000164000000059" type="checkbox" value="5110000164000000059" checked="checked"/>
							    </td>
							    <td class="inquire_item6"></td>
							    <td class="inquire_form6"></td>
							    <td class="inquire_item6"></td>
							    <td class="inquire_form6"></td>
							</tr>
			        	</table>
					</fieldset>
					<fieldset>
						<legend>制动系统</legend>
						<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
							<tr>
								<td class="inquire_item6">制动系统：</td>
							    <td class="inquire_form6">
							     	<input name="check_item" id="5110000164000000061" type="checkbox" value="5110000164000000061" checked="checked"/>
							    </td>
							    <td class="inquire_item6"></td>
							    <td class="inquire_form6"></td>
							    <td class="inquire_item6"></td>
							    <td class="inquire_form6"></td>
							</tr>
			        	</table>
					</fieldset>
					<fieldset>
						<legend>行走系统</legend>
						<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
							<tr>
							    <td class="inquire_item6">行走系统：</td>
							    <td class="inquire_form6">
							     	<input name="check_item" id="5110000164000000062" type="checkbox" value="5110000164000000062" checked="checked"/>
							    </td>
							    <td class="inquire_item6"></td>
							    <td class="inquire_form6"></td>
							    <td class="inquire_item6"></td>
							    <td class="inquire_form6"></td>
							</tr>
			        	</table>
					</fieldset>
					<fieldset>
						<legend>电子系统</legend>
						<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
							<tr>
							    <td class="inquire_item6">电子系统：</td>
							    <td class="inquire_form6">
							     	<input name="check_item" id="5110000164000000063" type="checkbox" value="5110000164000000063" checked="checked"/>
							    </td>
							    <td class="inquire_item6"></td>
							    <td class="inquire_form6"></td>
							    <td class="inquire_item6"></td>
							    <td class="inquire_form6"></td>
							</tr>
			        	</table>
					</fieldset>
					<fieldset>
						<legend>驾驶室及车身</legend>
						<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
							<tr>
							    <td class="inquire_item6">驾驶室及车身：</td>
							    <td class="inquire_form6">
							     	<input name="check_item" id="5110000164000000064" type="checkbox" value="5110000164000000064" checked="checked"/>
							    </td>
							    <td class="inquire_item6"></td>
							    <td class="inquire_form6"></td>
							    <td class="inquire_item6"></td>
							    <td class="inquire_form6"></td>
							</tr>
			        	</table>
					</fieldset>
					<fieldset>
						<legend>日常检查记录</legend>
						<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
							<tr>
							    <td class="inquire_item6">日常检查记录：</td>
							    <td class="inquire_form6">
							     	<input name="check_item" id="5110000164000000065" type="checkbox" value="5110000164000000065" checked="checked"/>
							    </td>
							    <td class="inquire_item6"></td>
							    <td class="inquire_form6"></td>
							    <td class="inquire_item6"></td>
							    <td class="inquire_form6"></td>
							</tr>
			        	</table>
					</fieldset>
					<% } %>
					<!-- 运输车辆检查 -->
					<% if(devType.startsWith("S08") && (!devType.startsWith("S0808"))){ %>
					<fieldset>
						<legend>发动机</legend>
						<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
							<tr>
								<td class="inquire_item6">启动性能：</td>
							    <td class="inquire_form6">
							     	<input name="check_item" id="5110000164000000006" type="checkbox" value="5110000164000000006" checked="checked"/>
							    </td>
							    <td class="inquire_item6">三滤：</td>
							    <td class="inquire_form6">
							     	<input name="check_item" id="5110000164000000007" type="checkbox" value="5110000164000000007" checked="checked"/>
							    </td>
							    <td class="inquire_item6">机油压力：</td>
							    <td class="inquire_form6">
							     	<input name="check_item" id="5110000164000000008" type="checkbox" value="5110000164000000008" checked="checked"/>
							    </td>
							</tr>
							<tr>
							    <td class="inquire_item6">各种皮带：</td>
							    <td class="inquire_form6">
							     	<input name="check_item" id="5110000164000000009" type="checkbox" value="5110000164000000009" checked="checked"/>
							    </td>
							    <td class="inquire_item6">冷却系统：</td>
							    <td class="inquire_form6">
							     	<input name="check_item" id="5110000164000000010" type="checkbox" value="5110000164000000010" checked="checked"/>
							    </td>
							    <td class="inquire_item6"></td>
							    <td class="inquire_form6"></td>
							</tr>
			        	</table>
					</fieldset>
					<fieldset>
						<legend>离合器</legend>
						<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
							<tr>
							    <td class="inquire_item6">离合器：</td>
							    <td class="inquire_form6">
							     	<input name="check_item" id="5110000164000000011" type="checkbox" value="5110000164000000011" checked="checked"/>
							    </td>
							    <td class="inquire_item6"></td>
							    <td class="inquire_form6"></td>
							    <td class="inquire_item6"></td>
							    <td class="inquire_form6"></td>
							</tr>
			        	</table>
					</fieldset>
					<fieldset>
						<legend>变速(分动)箱</legend>
						<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
							<tr>
								<td class="inquire_item6">变速(分动)箱：</td>
							    <td class="inquire_form6">
							     	<input name="check_item" id="5110000164000000012" type="checkbox" value="5110000164000000012" checked="checked"/>
							    </td>
							    <td class="inquire_item6"></td>
							    <td class="inquire_form6"></td>
							    <td class="inquire_item6"></td>
							    <td class="inquire_form6"></td>
							</tr>
			        	</table>
					</fieldset>
					<fieldset>
						<legend>差速器</legend>
						<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
							<tr>
								<td class="inquire_item6">差速器：</td>
							    <td class="inquire_form6">
							     	<input name="check_item" id="5110000164000000013" type="checkbox" value="5110000164000000013" checked="checked"/>
							    </td>
							    <td class="inquire_item6"></td>
							    <td class="inquire_form6"></td>
							    <td class="inquire_item6"></td>
							    <td class="inquire_form6"></td>
							</tr>
			        	</table>
					</fieldset>
					<fieldset>
						<legend>传动轴</legend>
						<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
							<tr>
							    <td class="inquire_item6">传动轴：</td>
							    <td class="inquire_form6">
							     	<input name="check_item" id="5110000164000000014" type="checkbox" value="5110000164000000014" checked="checked"/>
							    </td>
							    <td class="inquire_item6"></td>
							    <td class="inquire_form6"></td>
							    <td class="inquire_item6"></td>
							    <td class="inquire_form6"></td>
							</tr>
			        	</table>
					</fieldset>
					<fieldset>
						<legend>悬挂装置</legend>
						<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
							<tr>
							    <td class="inquire_item6">悬挂装置：</td>
							    <td class="inquire_form6">
							     	<input name="check_item" id="5110000164000000015" type="checkbox" value="5110000164000000015" checked="checked"/>
							    </td>
							    <td class="inquire_item6"></td>
							    <td class="inquire_form6"></td>
							    <td class="inquire_item6"></td>
							    <td class="inquire_form6"></td>
							</tr>
			        	</table>
					</fieldset>
					<fieldset>
						<legend>制动系统</legend>
						<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
							<tr>
							    <td class="inquire_item6">制动系统：</td>
							    <td class="inquire_form6">
							     	<input name="check_item" id="5110000164000000016" type="checkbox" value="5110000164000000016" checked="checked"/>
							    </td>
							    <td class="inquire_item6"></td>
							    <td class="inquire_form6"></td>
							    <td class="inquire_item6"></td>
							    <td class="inquire_form6"></td>
							</tr>
			        	</table>
					</fieldset>
					<fieldset>
						<legend>轴头轮胎</legend>
						<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
							<tr>
							    <td class="inquire_item6">轴头轮胎：</td>
							    <td class="inquire_form6">
							     	<input name="check_item" id="5110000164000000017" type="checkbox" value="5110000164000000017" checked="checked"/>
							    </td>
							    <td class="inquire_item6"></td>
							    <td class="inquire_form6"></td>
							    <td class="inquire_item6"></td>
							    <td class="inquire_form6"></td>
							</tr>
			        	</table>
					</fieldset>
					<fieldset>
						<legend>仪表电器</legend>
						<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
							<tr>
							    <td class="inquire_item6">仪表电器：</td>
							    <td class="inquire_form6">
							     	<input name="check_item" id="5110000164000000018" type="checkbox" value="5110000164000000018" checked="checked"/>
							    </td>
							    <td class="inquire_item6"></td>
							    <td class="inquire_form6"></td>
							    <td class="inquire_item6"></td>
							    <td class="inquire_form6"></td>
							</tr>
			        	</table>
					</fieldset>
					<fieldset>
						<legend>日常检查记录</legend>
						<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
							<tr>
							    <td class="inquire_item6">日常检查记录：</td>
							    <td class="inquire_form6">
							     	<input name="check_item" id="5110000164000000019" type="checkbox" value="5110000164000000019" checked="checked"/>
							    </td>
							    <td class="inquire_item6"></td>
							    <td class="inquire_form6"></td>
							    <td class="inquire_item6"></td>
							    <td class="inquire_form6"></td>
							</tr>
			        	</table>
					</fieldset>
					<% } %>
					<!-- 运输船舶检查S0808（不含S080805 ） -->
					<% if(devType.startsWith("S0808") && (!devType.startsWith("S080805"))){ %>
					<fieldset>
						<legend>轮机设备</legend>
						<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
							<tr>
								<td class="inquire_item6">主机：</td>
							    <td class="inquire_form6">
							     	<input name="check_item" id="5110000164000000071" type="checkbox" value="5110000164000000071" checked="checked"/>
							    </td>
							    <td class="inquire_item6">推进装置：</td>
							    <td class="inquire_form6">
							     	<input name="check_item" id="5110000164000000072" type="checkbox" value="5110000164000000072" checked="checked"/>
							    </td>
							    <td class="inquire_item6">发电机组：</td>
							    <td class="inquire_form6">
							     	<input name="check_item" id="5110000164000000073" type="checkbox" value="5110000164000000073" checked="checked"/>
							    </td>
							</tr>
							<tr>
								<td class="inquire_item6">舵机设备：</td>
							    <td class="inquire_form6">
							     	<input name="check_item" id="5110000164000000074" type="checkbox" value="5110000164000000074" checked="checked"/>
							    </td>
							    <td class="inquire_item6">锅炉：</td>
							    <td class="inquire_form6">
							     	<input name="check_item" id="5110000164000000075" type="checkbox" value="5110000164000000075" checked="checked"/>
							    </td>
							    <td class="inquire_item6">应急设备：</td>
							    <td class="inquire_form6">
							     	<input name="check_item" id="5110000164000000076" type="checkbox" value="5110000164000000076" checked="checked"/>
							    </td>
							</tr>
							<tr>
							    <td class="inquire_item6">防污染设备：</td>
							    <td class="inquire_form6">
							     	<input name="check_item" id="5110000164000000077" type="checkbox" value="5110000164000000077" checked="checked"/>
							    </td>
							    <td class="inquire_item6">空压机：</td>
							    <td class="inquire_form6">
							     	<input name="check_item" id="5110000164000000078" type="checkbox" value="5110000164000000078" checked="checked"/>
							    </td>
							    <td class="inquire_item6"></td>
							    <td class="inquire_form6"></td>
							</tr>
			        	</table>
					</fieldset>
					<fieldset>
						<legend>甲板设备</legend>
						<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
							<tr>
							    <td class="inquire_item6">锚设备：</td>
							    <td class="inquire_form6">
							     	<input name="check_item" id="5110000164000000080" type="checkbox" value="5110000164000000080" checked="checked"/>
							    </td>
							    <td class="inquire_item6">通导设备：</td>
							    <td class="inquire_form6">
							     	<input name="check_item" id="5110000164000000081" type="checkbox" value="5110000164000000081" checked="checked"/>
							    </td>
							    <td class="inquire_item6">救生设备：</td>
							    <td class="inquire_form6">
							     	<input name="check_item" id="5110000164000000082" type="checkbox" value="5110000164000000082" checked="checked"/>
							    </td>
							 </tr>
							 <tr>
							    <td class="inquire_item6">消防设备：</td>
							    <td class="inquire_form6">
							     	<input name="check_item" id="5110000164000000083" type="checkbox" value="5110000164000000083" checked="checked"/>
							    </td>
							    <td class="inquire_item6"></td>
							    <td class="inquire_form6"></td>
							    <td class="inquire_item6"></td>
							    <td class="inquire_form6"></td>
							</tr>
			        	</table>
					</fieldset>
					<fieldset>
						<legend>气爆设备</legend>
						<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
							<tr>
								<td class="inquire_item6">枪控设备：</td>
							    <td class="inquire_form6">
							     	<input name="check_item" id="5110000164000000085" type="checkbox" value="5110000164000000085" checked="checked"/>
							    </td>
							    <td class="inquire_item6">枪控设备：</td>
							    <td class="inquire_form6">
							     	<input name="check_item" id="5110000164000000086" type="checkbox" value="5110000164000000086" checked="checked"/>
							    </td>
							    <td class="inquire_item6">阵列收放设备：</td>
							    <td class="inquire_form6">
							     	<input name="check_item" id="5110000164000000087" type="checkbox" value="5110000164000000087" checked="checked"/>
							    </td>
							</tr>
			        	</table>
					</fieldset>
					<fieldset>
						<legend>其他</legend>
						<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
							<tr>
							    <td class="inquire_item6">其他：</td>
							    <td class="inquire_form6">
							     	<input name="check_item" id="5110000164000000088" type="checkbox" value="5110000164000000088" checked="checked"/>
							    </td>
							    <td class="inquire_item6"></td>
							    <td class="inquire_form6"></td>
							    <td class="inquire_item6"></td>
							    <td class="inquire_form6"></td>
							</tr>
			        	</table>
					</fieldset>
					<% } %>
					<!-- 可控震源S0623 -->
					<% if(devType.startsWith("S0623")){ %>
					<fieldset>
						<legend>HSE设施</legend>
						<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
							<tr>
							    <td class="inquire_item6">HSE设施：</td>
							    <td class="inquire_form6">
							     	<input name="check_item" id="5110000164000000089" type="checkbox" value="5110000164000000089" checked="checked"/>
							    </td>
							    <td class="inquire_item6"></td>
							    <td class="inquire_form6"></td>
							    <td class="inquire_item6"></td>
							    <td class="inquire_form6"></td>
							</tr>
			        	</table>
					</fieldset>
					<fieldset>
						<legend>整车外表渗漏、清洁情况</legend>
						<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
							<tr>
							    <td class="inquire_item6">整车外表渗漏、清洁情况：</td>
							    <td class="inquire_form6">
							     	<input name="check_item" id="5110000164000000090" type="checkbox" value="5110000164000000090" checked="checked"/>
							    </td>
							    <td class="inquire_item6"></td>
							    <td class="inquire_form6"></td>
							    <td class="inquire_item6"></td>
							    <td class="inquire_form6"></td>
							</tr>
			        	</table>
					</fieldset>
					<fieldset>
						<legend>发动机</legend>
						<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
							<tr>
								<td class="inquire_item6">机油液面：</td>
							    <td class="inquire_form6">
							     	<input name="check_item" id="5110000164000000092" type="checkbox" value="5110000164000000092" checked="checked"/>
							    </td>
							    <td class="inquire_item6">冷却液面：</td>
							    <td class="inquire_form6">
							     	<input name="check_item" id="5110000164000000093" type="checkbox" value="5110000164000000093" checked="checked"/>
							    </td>
							    <td class="inquire_item6">进气道连接件密封性：</td>
							    <td class="inquire_form6">
							     	<input name="check_item" id="5110000164000000094" type="checkbox" value="5110000164000000094" checked="checked"/>
							    </td>
							</tr>
			        	</table>
					</fieldset>
					<fieldset>
						<legend>液压系统</legend>
						<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
							<tr>
							    <td class="inquire_item6">液压系统：</td>
							    <td class="inquire_form6">
							     	<input name="check_item" id="5110000164000000095" type="checkbox" value="5110000164000000095" checked="checked"/>
							    </td>
							    <td class="inquire_item6"></td>
							    <td class="inquire_form6"></td>
							    <td class="inquire_item6"></td>
							    <td class="inquire_form6"></td>
							</tr>
			        	</table>
					</fieldset>
					<fieldset>
						<legend>电气系统</legend>
						<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
							<tr>
							    <td class="inquire_item6">电气系统：</td>
							    <td class="inquire_form6">
							     	<input name="check_item" id="5110000164000000096" type="checkbox" value="5110000164000000096" checked="checked"/>
							    </td>
							    <td class="inquire_item6"></td>
							    <td class="inquire_form6"></td>
							    <td class="inquire_item6"></td>
							    <td class="inquire_form6"></td>
							</tr>
			        	</table>
					</fieldset>
					<fieldset>
						<legend>灯光</legend>
						<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
							<tr>
							    <td class="inquire_item6">灯光：</td>
							    <td class="inquire_form6">
							     	<input name="check_item" id="5110000164000000097" type="checkbox" value="5110000164000000097" checked="checked"/>
							    </td>
							    <td class="inquire_item6"></td>
							    <td class="inquire_form6"></td>
							    <td class="inquire_item6"></td>
							    <td class="inquire_form6"></td>
							</tr>
			        	</table>
					</fieldset>
					<fieldset>
						<legend>轮胎</legend>
						<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
							<tr>
							    <td class="inquire_item6">轮胎：</td>
							    <td class="inquire_form6">
							     	<input name="check_item" id="5110000164000000098" type="checkbox" value="5110000164000000098" checked="checked"/>
							    </td>
							    <td class="inquire_item6"></td>
							    <td class="inquire_form6"></td>
							    <td class="inquire_item6"></td>
							    <td class="inquire_form6"></td>
							</tr>
			        	</table>
					</fieldset>
					<fieldset>
						<legend>日常检查记录</legend>
						<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
							<tr>
							    <td class="inquire_item6">日常检查记录：</td>
							    <td class="inquire_form6">
							     	<input name="check_item" id="5110000164000000099" type="checkbox" value="5110000164000000099" checked="checked"/>
							    </td>
							    <td class="inquire_item6"></td>
							    <td class="inquire_form6"></td>
							    <td class="inquire_item6"></td>
							    <td class="inquire_form6"></td>
							</tr>
			        	</table>
					</fieldset>
					<% } %>
					<!-- 挂机S08080501 -->
					<% if(devType.startsWith("S08080501")){ %>
					<fieldset>
						<legend>挂机</legend>
						<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
							<tr>
								<td class="inquire_item6">机体外观：</td>
							    <td class="inquire_form6">
							     	<input name="check_item" id="5110000164000000100" type="checkbox" value="5110000164000000100" checked="checked"/>
							    </td>
							    <td class="inquire_item6">燃油箱：</td>
							    <td class="inquire_form6">
							     	<input name="check_item" id="5110000164000000101" type="checkbox" value="5110000164000000101" checked="checked"/>
							    </td>
							    <td class="inquire_item6">油管：</td>
							    <td class="inquire_form6">
							     	<input name="check_item" id="5110000164000000102" type="checkbox" value="5110000164000000102" checked="checked"/>
							    </td>
							</tr>
							<tr>
								<td class="inquire_item6">防水帽钩：</td>
							    <td class="inquire_form6">
							     	<input name="check_item" id="5110000164000000103" type="checkbox" value="5110000164000000103" checked="checked"/>
							    </td>
							    <td class="inquire_item6">启动拉绳：</td>
							    <td class="inquire_form6">
							     	<input name="check_item" id="5110000164000000104" type="checkbox" value="5110000164000000104" checked="checked"/>
							    </td>
							    <td class="inquire_item6">发动机：</td>
							    <td class="inquire_form6">
							     	<input name="check_item" id="5110000164000000105" type="checkbox" value="5110000164000000105" checked="checked"/>
							    </td>
							</tr>
							<tr>
								<td class="inquire_item6">油门柄：</td>
							    <td class="inquire_form6">
							     	<input name="check_item" id="5110000164000000106" type="checkbox" value="5110000164000000106" checked="checked"/>
							    </td>
							    <td class="inquire_item6">正车倒车：</td>
							    <td class="inquire_form6">
							     	<input name="check_item" id="5110000164000000107" type="checkbox" value="5110000164000000107" checked="checked"/>
							    </td>
							    <td class="inquire_item6">循环水：</td>
							    <td class="inquire_form6">
							     	<input name="check_item" id="5110000164000000108" type="checkbox" value="5110000164000000108" checked="checked"/>
							    </td>
							</tr>
							<tr>
							    <td class="inquire_item6">高压线路：</td>
							    <td class="inquire_form6">
							     	<input name="check_item" id="5110000164000000109" type="checkbox" value="5110000164000000109" checked="checked"/>
							    </td>
							    <td class="inquire_item6">熄火开关：</td>
							    <td class="inquire_form6">
							     	<input name="check_item" id="5110000164000000110" type="checkbox" value="5110000164000000110" checked="checked"/>
							    </td>
							    <td class="inquire_item6"></td>
							    <td class="inquire_form6"></td>
							</tr>
			        	</table>
					</fieldset>
					<% } %>
					<!-- 发电机组检查S0901 -->
					<% if(devType.startsWith("S0901")){ %>
					<fieldset>
						<legend>发动机部分</legend>
						<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
							<tr>
								<td class="inquire_item6">启动性能：</td>
							    <td class="inquire_form6">
							     	<input name="check_item" id="5110000164000000112" type="checkbox" value="5110000164000000112" checked="checked"/>
							    </td>
							    <td class="inquire_item6">三滤：</td>
							    <td class="inquire_form6">
							     	<input name="check_item" id="5110000164000000113" type="checkbox" value="5110000164000000113" checked="checked"/>
							    </td>
							    <td class="inquire_item6">机油压力：</td>
							    <td class="inquire_form6">
							     	<input name="check_item" id="5110000164000000114" type="checkbox" value="5110000164000000114" checked="checked"/>
							    </td>
							</tr>
							<tr>
							    <td class="inquire_item6">各种皮带：</td>
							    <td class="inquire_form6">
							     	<input name="check_item" id="5110000164000000115" type="checkbox" value="5110000164000000115" checked="checked"/>
							    </td>
							    <td class="inquire_item6">冷却系统：</td>
							    <td class="inquire_form6">
							     	<input name="check_item" id="5110000164000000116" type="checkbox" value="5110000164000000116" checked="checked"/>
							    </td>
							    <td class="inquire_item6"></td>
							    <td class="inquire_form6"></td>
							</tr>
			        	</table>
					</fieldset>
					<fieldset>
						<legend>发电机部分</legend>
						<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
							<tr>
							    <td class="inquire_item6">紧急制动装置：</td>
							    <td class="inquire_form6">
							     	<input name="check_item" id="5110000164000000118" type="checkbox" value="5110000164000000118" checked="checked"/>
							    </td>
							    <td class="inquire_item6">自动保护装置：</td>
							    <td class="inquire_form6">
							     	<input name="check_item" id="5110000164000000119" type="checkbox" value="5110000164000000119" checked="checked"/>
							    </td>
							    <td class="inquire_item6">输出电压：</td>
							    <td class="inquire_form6">
							     	<input name="check_item" id="5110000164000000120" type="checkbox" value="5110000164000000120" checked="checked"/>
							    </td>
							 </tr>
							 <tr>
							    <td class="inquire_item6">各种仪表：</td>
							    <td class="inquire_form6">
							     	<input name="check_item" id="5110000164000000121" type="checkbox" value="5110000164000000121" checked="checked"/>
							    </td>
							    <td class="inquire_item6"></td>
							    <td class="inquire_form6"></td>
							    <td class="inquire_item6"></td>
							    <td class="inquire_form6"></td>
							</tr>
			        	</table>
					</fieldset>
					<fieldset>
						<legend>蓄电池</legend>
						<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
							<tr>
							    <td class="inquire_item6">蓄电池：</td>
							    <td class="inquire_form6">
							     	<input name="check_item" id="5110000164000000122" type="checkbox" value="5110000164000000122" checked="checked"/>
							    </td>
							    <td class="inquire_item6"></td>
							    <td class="inquire_form6"></td>
							    <td class="inquire_item6"></td>
							    <td class="inquire_form6"></td>
							</tr>
			        	</table>
					</fieldset>
					<fieldset>
						<legend>HSE设施</legend>
						<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
							<tr>
							    <td class="inquire_item6">HSE设施：</td>
							    <td class="inquire_form6">
							     	<input name="check_item" id="5110000164000000123" type="checkbox" value="5110000164000000123" checked="checked"/>
							    </td>
							    <td class="inquire_item6"></td>
							    <td class="inquire_form6"></td>
							    <td class="inquire_item6"></td>
							    <td class="inquire_form6"></td>
							</tr>
			        	</table>
					</fieldset>
					<fieldset>
						<legend>日常检查记录</legend>
						<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
							<tr>
							    <td class="inquire_item6">日常检查记录：</td>
							    <td class="inquire_form6">
							     	<input name="check_item" id="5110000164000000124" type="checkbox" value="5110000164000000124" checked="checked"/>
							    </td>
							    <td class="inquire_item6"></td>
							    <td class="inquire_form6"></td>
							    <td class="inquire_item6"></td>
							    <td class="inquire_form6"></td>
							</tr>
			        	</table>
					</fieldset>
					<% } %>
				</div>
				<div id="oper_div" style="margin-bottom:5px">
					<span class="tj_btn"><a href="#" onclick="submitInfo()"></a></span>
					<span class="gb_btn"><a href="#" onclick="newClose()"></a></span>
				</div>
			</div>
		</div>
	</form>
</body>
<script type="text/javascript"> 
	var inspectionTeamId='<%=inspectionTeamId%>';
	var devAccId='<%=devAccId%>';
	var devType='<%=devType%>';
	$(function(){
		var retObj = jcdpCallService("DevTeamCheckSrv", "getCheckDevInfo", "inspectionTeamId="+inspectionTeamId+"&devAccId="+devAccId);
		if(typeof retObj.teamdata!="undefined"){
			var teamdata = retObj.teamdata;
			$("#inspection_team_id").val(teamdata.inspection_team_id);
			$("#inspector").val(teamdata.check_person);
			$("#project_info_no").val(teamdata.project_info_no);
		}
		if(typeof retObj.devdata!="undefined"){
			var devdata = retObj.devdata;
			$("#dev_name").val(devdata.dev_name);
			$("#device_account_id").val(devdata.dev_acc_id);
			$("#dev_type").val(devdata.dev_type);
			$("#dev_model").val(devdata.dev_model);
		}
		$("#inspection_date").val(getCurrentDate());
	});
	
	function submitInfo(){
		//获取未选中的检查项
		var checkedItems="";
		$.each($("input[type='checkbox']"), function(i, n){
			if(n.checked==false){
				if (checkedItems == ''){
					checkedItems += n.value;
				}else{
					checkedItems += ","+n.value;
				}
			}
		});
		$("#checked_items").val(checkedItems);
		document.getElementById("form1").action = "<%=contextPath%>/rm/dm/saveInspectionInfo.srq";
		document.getElementById("form1").submit();
	}
</script>
</html>
 
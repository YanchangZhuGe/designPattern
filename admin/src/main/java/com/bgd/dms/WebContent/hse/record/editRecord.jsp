<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@page import="com.cnpc.jcdp.webapp.util.JcdpMVCUtil" %>
<%@page import="com.cnpc.jcdp.cfg.BeanFactory"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@ page import="java.util.*"%>
<%@ taglib uri="code" prefix="code"%> 
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	ISrvMsg resultMsg = OMSMVCUtil.getResponseMsg(request);
	String hse_accident_id = resultMsg.getValue("hse_accident_id");
	Map map  = resultMsg.getMsgElement("map").toMap();
	String index = "0";
	if(resultMsg.getValue("index")!=null){
		index=resultMsg.getValue("index");
	}
	int index22 = Integer.parseInt(index);
	
	String isProject = request.getParameter("isProject");
	 if(isProject==null||isProject.equals("")){
		isProject = resultMsg.getValue("isProject");
	 }

%> 
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>新建项目</title>
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" /> 
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/verify.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
</head>
<body>
<form name="form" id="form"  method="post" action="" >
<input type="hidden" id="hse_accident_id" name="hse_accident_id" value="<%=hse_accident_id %>"/>
<input type="hidden" id="hse_record_id" name="hse_record_id" value="<%=map.get("hseRecordId") %>"/>
<input type="hidden" id="isProject" name="isProject" value="<%=isProject %>"/>
<div id="new_table_box">
  <div id="new_table_box_content">
    <div id="new_table_box_bg">
		<div id="tag-container_3">
			  <ul id="tags" class="tags">
			    <li class="selectTag" id="tag3_0"><a href="#" onclick="getTab3(0)">基本信息</a></li>
			    <li id="tag3_1"><a href="#" onclick="getTab3(1)">事故原因分析</a></li>
			    <li id="tag3_2"><a href="#" onclick="getTab3(2)" >伤亡人员</a></li>
			    <li id="tag3_3"><a href="#" onclick="getTab3(3)" >经济损失</a></li>
			    <li id="tag3_4"><a href="#" onclick="getTab3(4)" >生态损失</a></li>
			    <li id="tag3_5"><a href="#" onclick="getTab3(5)" >汇报情况</a></li>
			  </ul>
			</div>
			<div id="tab_box" class="tab_box">
				<div id="tab_box_content0" class="tab_box_content">
					<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height" style="margin-top: 10px;">
					  <tr>
						  	<td class="inquire_item6">单位：</td>
							<td class="inquire_form6">
								<input type="hidden" id="second_org" name="second_org" class="input_width" value="<%=map.get("secondOrg")%>"/>
								<input type="text" id="second_org2" name="second_org2" class="input_width" <%if(!JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)||!JcdpMVCUtil.hasPermission("F_HSE_ORG_002", request)||!JcdpMVCUtil.hasPermission("F_HSE_ORG_003", request)){ %> readonly="readonly"<%} %> onkeydown="return noEdit(event)"  value="<%=map.get("secondOrgName") %>" />
								<%if(JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)&&JcdpMVCUtil.hasPermission("F_HSE_ORG_002", request)&&JcdpMVCUtil.hasPermission("F_HSE_ORG_003", request)){ %>
								<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="selectOrg()"/>
								<%} %>
							</td>
							<td class="inquire_item6">基层单位：</td>
							<td class="inquire_form6">
								<input type="hidden" id="third_org" name="third_org" class="input_width" value="<%=map.get("thirdOrg") %>"/>
								<input type="text" id="third_org2" name="third_org2" class="input_width"  <%if(!JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)||!JcdpMVCUtil.hasPermission("F_HSE_ORG_002", request)){ %>readonly="readonly"<%} %> onkeydown="return noEdit(event)"  value="<%=map.get("thirdOrgName")%>"/>
								<%if(JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)&&JcdpMVCUtil.hasPermission("F_HSE_ORG_002", request)){ %>
								<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="selectOrg2()"/>
								<%} %>
							</td>
							<td class="inquire_item6">下属单位：</td>
							<td class="inquire_form6">
								<input type="hidden" id="fourth_org" name="fourth_org" class="input_width" value="<%=map.get("fourthOrg") %>"/>
								<input type="text" id="fourth_org2" name="fourth_org2" class="input_width"  <%if(!JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)){ %>readonly="readonly"<%} %> onkeydown="return noEdit(event)"  value="<%=map.get("fourthOrgName")%>"/>
								<%if(JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)){ %>
								<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="selectOrg3()"/>
								<%} %>
							</td>
					  </tr>
					  <tr>
					    <td class="inquire_item6"><font color="red">*</font>事故名称：</td>
					    <td class="inquire_form6"><input type="text" id="accident_name" name="accident_name" class="input_width" value="<%=map.get("accidentName") %>" /></td>
					    <td class="inquire_item6"><font color="red">*</font>事故类型：</td>
					    <td class="inquire_form6">
					    	<select id="accident_type" name="accident_type" class="select_width">
					          <option value="" >请选择</option>
					          <%
					          	String sql = "select * from comm_coding_sort_detail where coding_sort_id='5110000042' and superior_code_id='0' and bsflag='0' order by coding_show_id desc";
					          	List list = BeanFactory.getQueryJdbcDAO().queryRecords(sql);
					          	for(int i=0;i<list.size();i++){
					          		Map map22 = (Map)list.get(i);
					          		String coding_id = (String)map22.get("codingCodeId");
					          		String coding_name = (String)map22.get("codingName");
					      	%>
					       	<option value="<%=coding_id %>" ><%=coding_name %></option>
					       	<%} %>
						    </select>
						</td>
					    <td class="inquire_item6"><font color="red">*</font>事故日期：</td>
					    <td class="inquire_form6"><input type="text" id="accident_date" name="accident_date" class="input_width" value="<%=map.get("accidentDate") %>" readonly="readonly"/>
					    &nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton1" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(accident_date,tributton1);" />&nbsp;</td>
					  </tr>	
					  <tr>
						   <td class="inquire_item6"><font color="red">*</font>事故等级：</td>
						    <td class="inquire_form6">
						    	<select id="accident_level" name="accident_level" class="select_width">
						          <option value="" >请选择</option>
						          <%
						          	String sql3 = "select * from comm_coding_sort_detail where coding_sort_id='5110000043' and superior_code_id='0' and bsflag='0' order by coding_show_id asc";
						          	List list3 = BeanFactory.getQueryJdbcDAO().queryRecords(sql3);
						          	for(int i=0;i<list3.size();i++){
						          		Map map33 = (Map)list3.get(i);
						          		String coding_id33 = (String)map33.get("codingCodeId");
						          		String coding_name33 = (String)map33.get("codingName");
							      	%>
							       	<option value="<%=coding_id33 %>" ><%=coding_name33 %></option>
							       	<%} %>
							    </select>
						  </td>
					    <td class="inquire_item6"><font color="red">*</font>事故地点：</td>
					    <td class="inquire_form6"><input type="text" id="accident_place" name="accident_place" value="<%=map.get("accidentPlace") %>" class="input_width"/></td>
					    <td class="inquire_item6"><font color="red">*</font>地点类型：</td>
					    <td class="inquire_form6"><input type="text" id="place_type" name="place_type" class="input_width" value="<%=map.get("placeType") %>"/></td>
					  </tr>	
					  <tr>
					    <td class="inquire_item6"><font color="red">*</font>是否通报：</td>
					    <td class="inquire_form6">
						<select id="bulletin_flag" name="bulletin_flag" class="select_width">
					       <option value="" >请选择</option>
					       <option value="1" >是</option>
					       <option value="0" >否</option>
						</select>
					    </td>
					    <td class="inquire_item6"><font color="red">*</font>是否结案：</td>
					    <td class="inquire_form6">
						<select id="case_flag" name="case_flag" class="select_width" onclick="caseMust()">
					       <option value="" >请选择</option>
					       <option value="1" >是</option>
					       <option value="0" >否</option>
						</select>
						</td>
					    <td class="inquire_item6"><font color="red">*</font>是否责任事故：</td>
					    <td class="inquire_form6">
						<select id="duty_flag" name="duty_flag" class="select_width">
					       <option value="" >请选择</option>
					       <option value="1" >是</option>
					       <option value="0" >否</option>
						</select>
					    </td>
					  </tr>
					  <tr>
					    <td class="inquire_item6"><font id="case_must" color="red">*</font>结案日期：</td>
					    <td class="inquire_form6"><input type="text" id="case_date" name="case_date" class="input_width" value="<%=map.get("caseDate") %>" readonly="readonly"/>
					    &nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton4" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(case_date,tributton4);" />&nbsp;</td>
					  <td class="inquire_item6"><font color="red">*</font>是否属于工作场所：</td>
					    <td class="inquire_form6">
						<select id="workplace_flag" name="workplace_flag" class="select_width">
					       <option value="" >请选择</option>
					       <option value="1" >是</option>
					       <option value="0" >否</option>
						</select>
					    </td>
					    <td class="inquire_item6"><font color="red">*</font>是否为承包商：</td>
					    <td class="inquire_form6">
						<select id="out_flag" name="out_flag" class="select_width" onclick="outMust()">
					       <option value="" >请选择</option>
					       <option value="1" >是</option>
					       <option value="0" >否</option>
						</select>
						</td>
					  </tr>
					  <tr>
					  	<td class="inquire_item6"><font id="out_must1" color="red">*</font>承包商名称：</td>
					    <td class="inquire_form6"><input type="text" id="out_name" name="out_name" class="input_width"  value="<%=map.get("outName") %>"/></td>
					    <td class="inquire_item6"><font id="out_must2" color="red">*</font>承包商类型：</td>
					    <td class="inquire_form6">
					    <select id="out_type" name="out_type" class="select_width">
					       <option value="" >请选择</option>
					       <option value="1" >集团内</option>
					       <option value="0" >集团外</option>
						</select>
					    </td>
					  </tr>	
					  <tr>
					    <td class="inquire_item6"><font color="red">*</font>事故经过：</td>
					    <td class="inquire_form6" colspan="5"><textarea id="accident_course" name="accident_course"   class="textarea" ><%=map.get("accidentCourse") %></textarea></td>
					  </tr>	
					</table>
				</div>
				<div id="tab_box_content1" class="tab_box_content" style="display:none;" >
					<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height" style="margin-top: 10px;">
					  <tr>
					    <td class="inquire_item6">风险消减情况：</td>
					    <td class="inquire_form6"><input type="text" id="accident_risk" name="accident_risk" class="input_width"  value="<%=map.get("accidentRisk") %>"/></td>
					    <td class="inquire_item6"></td>
					    <td class="inquire_item6"></td>
					    <td class="inquire_item6"></td>
					    <td class="inquire_form6"></td>
					  </tr>
					  <tr>
					    <td class="inquire_item6"><font color="red">*</font>直接原因：</td>
					    <td class="inquire_form6" colspan="5"><textarea id="first_reason" name="first_reason"   class="textarea" ><%=map.get("firstReason") %></textarea></td>
					  </tr>	
					  <tr>
					    <td class="inquire_item6"><font color="red">*</font>间接原因：</td>
					    <td class="inquire_form6" colspan="5"><textarea id="second_reason" name="second_reason"   class="textarea" ><%=map.get("secondReason") %></textarea></td>
					  </tr>	
					  <tr>
					    <td class="inquire_item6"><font color="red">*</font>防范措施：</td>
					    <td class="inquire_form6" colspan="5"><textarea id="accident_step" name="accident_step"   class="textarea" ><%=map.get("accidentStep") %></textarea></td>
					  </tr>	
					  <tr>
					    <td class="inquire_item6"><font color="red">*</font>验证结果：</td>
					    <td class="inquire_form6" colspan="5"><textarea id="accident_test" name="accident_test"   class="textarea" ><%=map.get("accidentTest") %></textarea></td>
					  </tr>	
					  <tr>
					    <td class="inquire_item6">备注：</td>
					    <td class="inquire_form6" colspan="5"><textarea id="accident_note" name="accident_note"   class="textarea" ><%=map.get("accidentNote") %></textarea></td>
					  </tr>	
					</table>
				</div>
				<div id="tab_box_content2" class="tab_box_content" style="display:none;">
				<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height" style="margin-top: 10px;">
					  <tr >
					        <td align="center">急性工业中毒：</td>
					        <td ><input type="text" id="number_toxic" name="number_toxic" class="input_width" value="<%=map.get("numberToxic") %>" /></input></td>
					        <td ></td>
					        <td ></td>
				        </tr>
					  <tr class="bt_info">
				    	    <td></td>
				            <td>死亡(单位:人)</td>
				            <td>重伤(单位:人)</td>		
				            <td>轻伤(单位:人)</td>
				        </tr>
				        <tr class="odd">
				        	<td >本企业</td>
				        	<input type="hidden" id="hse_number_id0" name="hse_number_id0" value=""></input>
				        	<input type="hidden" id="type0" name="type0" value="1"></input>
				        	<td ><input type="text" id="number_die0" name="number_die0" class="input_width"  onchange="allDie()"/></input></td>
				        	<td ><input type="text" id="number_harm0" name="number_harm0" class="input_width"  onchange="allHarm()"/></td>
				        	<td ><input type="text" id="number_injure0" name="number_injure0" class="input_width"  onchange="allInjure()"/></td>
				        </tr>
				         <tr class="even">
				        	<td >外部承包商</td>
				        	<input type="hidden" id="hse_number_id1" name="hse_number_id1" value=""></input>
				        	<input type="hidden" id="type1" name="type1" value="2"></input>
				        	<td ><input type="text" id="number_die1" name="number_die1" class="input_width" onchange="allDie()"/></input></td>
				        	<td ><input type="text" id="number_harm1" name="number_harm1" class="input_width"  onchange="allHarm()"/></td>
				        	<td ><input type="text" id="number_injure1" name="number_injure1" class="input_width"  onchange="allInjure()"/></td>
				        </tr>
				         <tr class="odd">
				        	<td >股份承包商</td>
				        	<input type="hidden" id="hse_number_id2" name="hse_number_id2" value=""></input>
				        	<input type="hidden" id="type2" name="type2" value="3"></input>
				        	<td ><input type="text" id="number_die2" name="number_die2" class="input_width"  onchange="allDie()"/></input></td>
				        	<td ><input type="text" id="number_harm2" name="number_harm2" class="input_width"  onchange="allHarm()"/></td>
				        	<td ><input type="text" id="number_injure2" name="number_injure2" class="input_width" onchange="allInjure()" /></td>
				        </tr>
				         <tr class="even">
				        	<td >集团承包商</td>
				        	<input type="hidden" id="hse_number_id3" name="hse_number_id3" value=""></input>
				        	<input type="hidden" id="type3" name="type3" value="4"></input>
				        	<td ><input type="text" id="number_die3" name="number_die3" class="input_width"  onchange="allDie()"/></input></td>
				        	<td ><input type="text" id="number_harm3" name="number_harm3" class="input_width"  onchange="allHarm()"/></td>
				        	<td ><input type="text" id="number_injure3" name="number_injure3" class="input_width"  onchange="allInjure()"/></td>
				        </tr>
				         <tr class="odd">
				        	<td >第三方</td>
				        	<input type="hidden" id="hse_number_id4" name="hse_number_id4" value=""></input>
				        	<input type="hidden" id="type4" name="type4" value="5"></input>
				        	<td ><input type="text" id="number_die4" name="number_die4" class="input_width"  onchange="allDie()"/></input></td>
				        	<td ><input type="text" id="number_harm4" name="number_harm4" class="input_width"  onchange="allHarm()"/></td>
				        	<td ><input type="text" id="number_injure4" name="number_injure4" class="input_width"  onchange="allInjure()"/></td>
				        </tr>
				        <tr class="even">
				        	<td >合计</td>
				        	<td ><input type="text" id="die_all" name="die_all" class="input_width" /></input></td>
				        	<td ><input type="text" id="harm_all" name="harm_all" class="input_width" /></td>
				        	<td ><input type="text" id="injure_all" name="injure_all" class="input_width" /></td>
				        </tr>    
					</table>
				</div>
				<div id="tab_box_content3" class="tab_box_content" style="display:none;">
					<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height" style="margin-top: 10px;">
					  <tr>
						  <td class="inquire_item6"><font color="red">*</font>直接损失：</td>
				      	  <td class="inquire_form6">
				      	  <input type="text" id="money_lose" name="money_lose" class="input_width"  value="<%=map.get("moneyLose") %>"/>元
				      	  </td>
				      	  <td class="inquire_item6"><font color="red">*</font>其他损失：</td>
					      	<td class="inquire_form6">
					      	<input type="text" id="other_lose" name="other_lose" class="input_width" value="<%=map.get("otherLose") %>"/>元
					      	</td>
					    <td class="inquire_item6"><font color="red">*</font>经济损失合计：</td>
					    <td class="inquire_form6"><input type="text" id="all_lose" name="all_lose" class="input_width"  value="<%=map.get("allLose") %>"/>元</td>
					  </tr>
					  <tr>
					    <td class="inquire_item6"><font color="red">*</font>损失工时：</td>
					    <td class="inquire_form6"><input type="text" id="lose_hours" name="lose_hours" class="input_width" value="<%=map.get("loseHours") %>" />小时</td>
					    <td class="inquire_item6"></td>
					    <td class="inquire_item6"></td>
					    <td class="inquire_item6"></td>
					    <td class="inquire_item6"></td>
					  </tr>
					</table>
				</div>
				<div id="tab_box_content4" class="tab_box_content"  style="display:none;">
					<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height" style="margin-top: 10px;">
					  <tr align="left">
				      	<td width="10%" align="center">环境污染类型：</td>
					    <td align="left">
					    	<input type="hidden" id="pollution_type" name="pollution_type" value=""/>
					      	<input type="checkbox"  name="selected" id="selected1" value="1">废水</input>&nbsp;&nbsp;
					      	<input type="checkbox"  name="selected" id="selected2" value="2">废气</input>&nbsp;&nbsp;
					      	<input type="checkbox"  name="selected" id="selected3" value="3">噪音</input>&nbsp;&nbsp;
					      	<input type="checkbox"  name="selected" id="selected4" value="4">固体废弃物</input>
				      	</td>
					  </tr>
					  <tr>
					  	<td></td>
					 	<td>
					  		<span class="zj" style="float: right;padding-right: 10px;"><a href="#" onclick="toAddLine()" title="JCDP_btn_add"></a></span>
					  	</td>
					  </tr>
					  <tr>
					  	<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height" id="lineTable">
					  		<input type="hidden" id="hse_environment_id" name="hse_environment_id" value=""></input>
      						<input type="hidden" id="lineNum" name="lineNum" value="0"></input>
      						<input type="hidden" id="orders" name="orders" value="0"></input>
					  		<tr>
					  			<td class="bt_info_odd">删除</td>
					  			<td class="bt_info_even">泄漏品中文名称</td>
					  			<td class="bt_info_odd">泄漏量(Kg)</td>
					  			<td class="bt_info_even">排放数量</td>
					  			<td class="bt_info_odd">等价数量</td>
					  			<td class="bt_info_even">CAS登记号</td>
					  		</tr>
					  	</table>
					  </tr>
					</table>
				</div>
				<div id="tab_box_content5" class="tab_box_content" style="display:none;">
				<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height" style="margin-top: 10px;">
					  <tr>
				      	<td class="inquire_item6">事故报告时间：</td>
					    <td class="inquire_form6"><input type="text" id="report_date" name="report_date" class="input_width" readonly="readonly" value="<%=map.get("reportDate") %>"/>
					    &nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton2" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(report_date,tributton2);" />&nbsp;</td>
				      	  <td class="inquire_item6">报告人：</td>
					      	<td class="inquire_form6">
					      	<input type="text" id="report_name" name="report_name" class="input_width" value="<%=map.get("reportName") %>"/>
					      	</td>
					    <td class="inquire_item6">联系人：</td>
					    <td class="inquire_form6"><input type="text" id="contact_name" name="contact_name" class="input_width" value="<%=map.get("contactName") %>" /></td>
					  </tr>
					  <tr>
					    <td class="inquire_item6">电话：</td>
					    <td class="inquire_form6"><input type="text" id="phone" name="phone" class="input_width" value="<%=map.get("phone") %>" /></td>
					    <td class="inquire_item6">填表日期：</td>
					    <td class="inquire_form6"><input type="text" id="table_date" name="table_date" class="input_width" readonly="readonly" value="<%=map.get("tableDate") %>"/>
					    &nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton3" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(table_date,tributton3);" />&nbsp;</td>
					    <td class="inquire_item6">填表人：</td>
					    <td class="inquire_form6"><input type="text" id="table_person" name="table_person" class="input_width" value="<%=map.get("tablePerson") %>" /></td>
					  </tr>
					  <tr>
					    <td class="inquire_item6">责任追究情况：</td>
					    <td class="inquire_form6"><input type="text" id="duty_id" name="duty_id" class="input_width" value="<%=map.get("dutyId") %>" /></td>
					    <td class="inquire_item6">其他损失情况：</td>
					    <td class="inquire_form6"><input type="text" id="lose_id" name="lose_id" class="input_width" value="<%=map.get("loseId") %>" /></td>
					    <td class="inquire_item6">事故材料：</td>
					    <td class="inquire_form6"><input type="text" id="stuff_id" name="stuff_id" class="input_width" value="<%=map.get("stuffId") %>" /></td>
					  </tr>	
					</table>
				</div>
				<input  type="hidden"	id="selectedTagIndex" name="selectedTagIndex" value=""></input>
</div>
			<div id="oper_div">
				<span class="tj_btn"><a href="#" onclick="submitButton()"></a></span>
				<span class="gb_btn"><a href="#" onclick="closeButton()"></a></span>
			</div>
</div>
</div> 
</div>
</form>
</body>

<script type="text/javascript">

var selectedTagIndex = 0;//document.getElementById("tag3_0").parentElement;
var showTabBox = document.getElementById("tab_box_content0");

function noEdit(event){
	if(event.keyCode==8|| event.keyCode ==37 || event.keyCode ==39){
		return true;
	}else{
		return false;
	}
}

document.getElementById("accident_level").value='<%=map.get("accidentLevel")%>';
document.getElementById("workplace_flag").value='<%=map.get("workplaceFlag")%>';
document.getElementById("out_flag").value='<%=map.get("outFlag")%>';
document.getElementById("out_type").value='<%=map.get("outType")%>';
document.getElementById("accident_type").value='<%=map.get("accidentType")%>';
document.getElementById("bulletin_flag").value='<%=map.get("bulletinFlag")%>';
document.getElementById("case_flag").value='<%=map.get("caseFlag")%>';
document.getElementById("duty_flag").value='<%=map.get("dutyFlag")%>';
var hse_accident_id = '<%=hse_accident_id%>';

document.getElementById("selected1").checked = false;
document.getElementById("selected2").checked = false;
document.getElementById("selected3").checked = false;
document.getElementById("selected4").checked = false;
var pollution_type = '<%=map.get("pollutionType")%>';
var selected = document.getElementsByName("selected");
if(pollution_type!=null&&pollution_type!=""){
	var temp = pollution_type.split(",");
	for(var j=0;j<temp.length;j++){
		document.getElementById("selected"+temp[j]).checked = true;
	}
}

toEdit();
outMust();
caseMust();

if(hse_accident_id!=""){
	var index = <%=index22 %>;
	getTab3(index);
}

if(hse_accident_id!=null&&hse_accident_id!=""){
	var querySql = "select * from bgp_hse_accident_number n where n.bsflag='0' and n.hse_accident_id='"+hse_accident_id+"' order by type asc";
	var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'pageSize=10000&querySql='+querySql);
	var datas = queryRet.datas;
	var die = 0;
	var harm =0;
	var injure = 0;
		for (var i = 0; i < 5; i++) {
			if(datas!=null&&datas!=""){
				document.getElementById("hse_number_id"+i).value = datas[i].hse_number_id;
				document.getElementById("number_die"+i).value = datas[i].number_die;
				document.getElementById("number_harm"+i).value = datas[i].number_harm;
				document.getElementById("number_injure"+i).value = datas[i].number_injure;
			}else{
				document.getElementById("hse_number_id"+i).value = "";
				document.getElementById("number_die"+i).value = "";
				document.getElementById("number_harm"+i).value = "";
				document.getElementById("number_injure"+i).value = "";
			}
			
			die = die+Number(document.getElementById("number_die"+i).value);
			harm = harm+Number(document.getElementById("number_harm"+i).value);
			injure = injure+Number(document.getElementById("number_injure"+i).value);
		}
		document.getElementById("die_all").value = die;
		document.getElementById("harm_all").value = harm;
		document.getElementById("injure_all").value = injure;
}

	
function getTab3(index) {  
	if(hse_accident_id==""){
		alert("请先填写基本信息");
		return;
	}
	var selectedTag = document.getElementById("tag3_"+selectedTagIndex);
	var selectedTabBox = document.getElementById("tab_box_content"+selectedTagIndex)
	selectedTag.className ="";
	selectedTabBox.style.display="none";

	selectedTagIndex = index;
	
	selectedTag = document.getElementById("tag3_"+selectedTagIndex);
	selectedTabBox = document.getElementById("tab_box_content"+selectedTagIndex)
	selectedTag.className ="selectTag";
	selectedTabBox.style.display="block";
	document.getElementById("selectedTagIndex").value=selectedTagIndex;
}

function outMust(){
	if(document.getElementById("out_flag").value=="1"){
		document.getElementById("out_must1").style.display="";
		document.getElementById("out_must2").style.display="";
		document.getElementById("out_name").disabled="";
		document.getElementById("out_type").disabled="";
	}else{
		document.getElementById("out_must1").style.display="none";
		document.getElementById("out_must2").style.display="none";
		document.getElementById("out_name").disabled="disabled";
		document.getElementById("out_type").disabled="disabled";
	}
}


function caseMust(){
	if(document.getElementById("case_flag").value=="1"){
		document.getElementById("case_must").style.display="";
	}else{
		document.getElementById("case_must").style.display="none";
	}
}

function allDie(){
	var number_die0 = document.getElementById("number_die0").value;
	var number_die1 = document.getElementById("number_die1").value;
	var number_die2 = document.getElementById("number_die2").value;
	var number_die3 = document.getElementById("number_die3").value;
	var number_die4 = document.getElementById("number_die4").value;
	number_die0 = Number(number_die0);
	number_die1 = Number(number_die1);
	number_die2 = Number(number_die2);
	number_die3 = Number(number_die3);
	number_die4 = Number(number_die4);
	document.getElementById("die_all").value=number_die0+number_die1+number_die2+number_die3+number_die4;
}

function allHarm(){
	var number_harm0 = document.getElementById("number_harm0").value;
	var number_harm1 = document.getElementById("number_harm1").value;
	var number_harm2 = document.getElementById("number_harm2").value;
	var number_harm3 = document.getElementById("number_harm3").value;
	var number_harm4 = document.getElementById("number_harm4").value;
	number_harm0 = Number(number_harm0);
	number_harm1 = Number(number_harm1);
	number_harm2 = Number(number_harm2);
	number_harm3 = Number(number_harm3);
	number_harm4 = Number(number_harm4);
	document.getElementById("harm_all").value=number_harm0+number_harm1+number_harm2+number_harm3+number_harm4;
}

function allInjure(){
	var number_injure0 = document.getElementById("number_injure0").value;
	var number_injure1 = document.getElementById("number_injure1").value;
	var number_injure2 = document.getElementById("number_injure2").value;
	var number_injure3 = document.getElementById("number_injure3").value;
	var number_injure4 = document.getElementById("number_injure4").value;
	number_injure0 = Number(number_injure0);
	number_injure1 = Number(number_injure1);
	number_injure2 = Number(number_injure2);
	number_injure3 = Number(number_injure3);
	number_injure4 = Number(number_injure4);
	document.getElementById("injure_all").value=number_injure0+number_injure1+number_injure2+number_injure3+number_injure4;
}

function submitButton(){
	var form = document.getElementById("form");
	form.action="<%=contextPath%>/hse/accident/addRecord.srq";
	if(document.getElementById("tab_box_content0").style.display==""||document.getElementById("tab_box_content0").style.display=="block"){
		if(checkText0()){
			return;
		}
	}
	if(document.getElementById("tab_box_content1").style.display==""||document.getElementById("tab_box_content1").style.display=="block"){
		if(checkText1()){
			return;
		}
	}
	if(document.getElementById("tab_box_content2").style.display==""||document.getElementById("tab_box_content2").style.display=="block"){
		if(checkText2()){
			return;
		}
	}
	if(document.getElementById("tab_box_content3").style.display==""||document.getElementById("tab_box_content3").style.display=="block"){
		if(checkText3()){
			return;
		}
	}
	if(document.getElementById("tab_box_content4").style.display==""||document.getElementById("tab_box_content4").style.display=="block"){
		form.action="<%=contextPath%>/hse/accident/addRecord.srq?enviFlag=0";
	}
	if(document.getElementById("tab_box_content5").style.display==""||document.getElementById("tab_box_content5").style.display=="block"){
		form.action="<%=contextPath%>/hse/accident/addRecord2.srq";
	}
	
	var type = "";
	var selected = document.getElementsByName("selected");
	for(var i=0; i<selected.length;i++){
		if(selected[i].checked==true){
			if(type!="") type += ",";
			type += selected[i].value;
		}
	}
	document.getElementById("pollution_type").value = type;
	debugger;
	var orders = "";
	var order = document.getElementsByName("order");
	for(var j=0;j<order.length;j++){
		if(orders!="") orders +=",";
		orders +=order[j].value;
	}
	document.getElementById("orders").value = orders;
	
	form.submit();
}

function toAddLine(hse_environment_id,leak_name,leak_num,emission_num,equal_num,cas_id){
	
	var hse_environment_id = hse_environment_id ? hse_environment_id : "";
	var leak_name = leak_name ? leak_name : "";
	var leak_num = leak_num ? leak_num : "";
	var emission_num = emission_num ? emission_num : "";
	var equal_num = equal_num ? equal_num : "";
	var cas_id = cas_id ? cas_id : "";
	
	var rowNum = document.getElementById("lineNum").value;	
	
	var table=document.getElementById("lineTable");
	
	var lineId = "row_" + rowNum;
	var autoOrder = document.getElementById("lineTable").rows.length;
	var newTR = document.getElementById("lineTable").insertRow(autoOrder);
	newTR.id = lineId;
	var tdClass = 'even';
	if(autoOrder%2==0){
		tdClass = 'odd';
	}
	
	var td = newTR.insertCell(0);
	td.innerHTML = "<input type='hidden' id='hse_environment_id"+rowNum+"' name='hse_environment_id"+rowNum+"' value='"+hse_environment_id+"' /><input type='hidden' name='order' value='" + rowNum + "'/><img src='<%=contextPath%>/images/delete.png' width='16' height='16' style='cursor:hand;' onclick='deleteLine(\""+lineId+"\")'/>";
    td.className = tdClass+'_odd';
    if(autoOrder%2==0){
		td.style.background = "#f6f6f6";
	}else{
		td.style.background = "#e3e3e3";
	}
	
    td = newTR.insertCell(1);
    td.innerHTML = "<input type='text' id='leak_name"+rowNum+"' name='leak_name"+rowNum+"' value='"+leak_name+"' />";
    td.className =tdClass+'_even'
    if(autoOrder%2==0){
		td.style.background = "#FFFFFF";
	}else{
		td.style.background = "#ebebeb";
	}
    
    td = newTR.insertCell(2);
    td.innerHTML = "<input type='text' id='leak_num"+rowNum+"' name='leak_num"+rowNum+"' value='"+leak_num+"' onkeydown='return isNumber(event)'/>";
    td.className =tdClass+'_odd'
    if(autoOrder%2==0){
		td.style.background = "#f6f6f6";
	}else{
		td.style.background = "#e3e3e3";
	}

    td = newTR.insertCell(3);
    td.innerHTML = "<input type='text' id='emission_num"+rowNum+"' name='emission_num"+rowNum+"' value='"+emission_num+"' onkeydown='return isNumber(event)'/>";
    td.className =tdClass+'_even'
    if(autoOrder%2==0){
		td.style.background = "#FFFFFF";
	}else{
		td.style.background = "#ebebeb";
	}

    td = newTR.insertCell(4);
    td.innerHTML = "<input type='text' id='equal_num"+rowNum+"' name='equal_num"+rowNum+"' value='"+equal_num+"' onkeydown='return isNumber(event)'/>";
    td.className =tdClass+'_odd'
    if(autoOrder%2==0){
		td.style.background = "#f6f6f6";
	}else{
		td.style.background = "#e3e3e3";
	}

    td = newTR.insertCell(5);
    td.innerHTML = "<input type='text' id='cas_id"+rowNum+"' name='cas_id"+rowNum+"' value='"+cas_id+"' />";
    td.className =tdClass+'_even'
    if(autoOrder%2==0){
		td.style.background = "#FFFFFF";
	}else{
		td.style.background = "#ebebeb";
	}
	
	document.getElementById("lineNum").value = parseInt(rowNum) + 1;
}

function deleteLine(lineId){		
	var rowNum = lineId.split('_')[1];
	var hse_environment_id = document.getElementById("hse_environment_id"+rowNum).value;
	var rowNum2 = document.getElementById("lineNum").value;	
	var line = document.getElementById(lineId);		
	line.parentNode.removeChild(line);
	
//	if(hse_dan_ids!="") hse_dan_ids += ",";
//	hse_dan_ids += hse_dan_id; 
}

function isNumber(){
	if(event.keyCode!=8&&event.keyCode!=48&&event.keyCode!=49&&event.keyCode!=50&&event.keyCode!=51&&event.keyCode!=52&&event.keyCode!=53&&event.keyCode!=54&&event.keyCode!=55&&event.keyCode!=56&&event.keyCode!=57&&event.keyCode!=96&&event.keyCode!=97&&event.keyCode!=98&&event.keyCode!=99&&event.keyCode!=100&&event.keyCode!=101&&event.keyCode!=102&&event.keyCode!=103&&event.keyCode!=104&&event.keyCode!=105&&event.keyCode!=110&&event.keyCode!=190){
		return false;
	}
}

function closeButton(){
	var ctt = top.frames('list');
	ctt.refreshData();
	newClose();
}



function toEdit(){
	var checkSql="select e.* from bgp_hse_accident_news t left join bgp_hse_accident_record r on t.hse_accident_id=r.hse_accident_id and r.bsflag='0' left join bgp_hse_record_environ e on r.hse_record_id=e.hse_record_id where t.bsflag='0' and t.hse_accident_id='<%=hse_accident_id%>' order by order_num asc";
    var queryRet = syncRequest('Post','<%=request.getContextPath()%>'+appConfig.queryListAction,'querySql='+checkSql);
	var datas = queryRet.datas;
	
	debugger;
	for(var j =1;j <document.getElementById("lineTable")!=null && j < document.getElementById("lineTable").rows.length ;){
		document.getElementById("lineTable").deleteRow(j);
	}
	if(datas!=null&&datas!=""){
		for(var i=0;i<datas.length;i++){
			toAddLine(
					datas[i].hse_environment_id ? datas[i].hse_environment_id : "",
					datas[i].leak_name ? datas[i].leak_name : "",
					datas[i].leak_num ? datas[i].leak_num : "",
					datas[i].emission_num ? datas[i].emission_num : "",
					datas[i].equal_num ? datas[i].equal_num : "",
					datas[i].cas_id ? datas[i].cas_id : ""
				);
		}
	}
	
	
}

function selectOrg(){
    var teamInfo = {
        fkValue:"",
        value:""
    };
    window.showModalDialog('<%=contextPath%>/common/selectOrgSub.jsp',teamInfo);
    if(teamInfo.fkValue!=""){
    	document.getElementById("second_org").value = teamInfo.fkValue;
        document.getElementById("second_org2").value = teamInfo.value;
    }
}

function selectOrg2(){
    var teamInfo = {
        fkValue:"",
        value:""
    };
    var second = document.getElementById("second_org").value;
	var org_id="";
		var checkSql="select t.org_id from comm_org_subjection t where t.bsflag='0' and t.org_subjection_id='"+second+"'";
	   	var queryRet = syncRequest('Post','<%=request.getContextPath()%>'+appConfig.queryListAction,'querySql='+checkSql);
		var datas = queryRet.datas;
		if(datas==null||datas==""){
		}else{
			org_id = datas[0].org_id; 
	    }
		    window.showModalDialog('<%=contextPath%>/common/selectOrgSub.jsp?orgId='+org_id,teamInfo);
		    if(teamInfo.fkValue!=""){
		    	 document.getElementById("third_org").value = teamInfo.fkValue;
		        document.getElementById("third_org2").value = teamInfo.value;
			}
   
}

function selectOrg3(){
    var teamInfo = {
        fkValue:"",
        value:""
    };
    var third = document.getElementById("third_org").value;
	var org_id="";
		var checkSql="select t.org_id from comm_org_subjection t where t.bsflag='0' and t.org_subjection_id='"+third+"'";
	   	var queryRet = syncRequest('Post','<%=request.getContextPath()%>'+appConfig.queryListAction,'querySql='+checkSql);
		var datas = queryRet.datas;
		if(datas==null||datas==""){
		}else{
			org_id = datas[0].org_id; 
	    }
		    window.showModalDialog('<%=contextPath%>/common/selectOrgSub.jsp?orgId='+org_id,teamInfo);
		    if(teamInfo.fkValue!=""){
		    	 document.getElementById("fourth_org").value = teamInfo.fkValue;
		        document.getElementById("fourth_org2").value = teamInfo.value;
			}
}

function checkText0(){
	var second_org2=document.getElementById("second_org2").value;
	var third_org2=document.getElementById("third_org2").value;
	var fourth_org2=document.getElementById("fourth_org2").value;
	var accident_name=document.getElementById("accident_name").value;
	var accident_type=document.getElementById("accident_type").value;
	var accident_level=document.getElementById("accident_level").value;
	var accident_date=document.getElementById("accident_date").value;
	var accident_place=document.getElementById("accident_place").value;
	var place_type=document.getElementById("place_type").value;
	var bulletin_flag=document.getElementById("bulletin_flag").value;
	var case_flag=document.getElementById("case_flag").value;
	var case_date=document.getElementById("case_date").value;
	var duty_flag=document.getElementById("duty_flag").value;
	var workplace_flag = document.getElementById("workplace_flag").value;
	var out_flag = document.getElementById("out_flag").value;
	var out_name = document.getElementById("out_name").value;
	var out_type = document.getElementById("out_type").value;
	var accident_course = document.getElementById("accident_course").value;
	if(second_org2==""){
		document.getElementById("second_org").value = "";
	}
	if(third_org2==""){
		document.getElementById("third_org").value="";
	}
	if(fourth_org2==""){
		document.getElementById("fourth_org").value="";
	}
	if(accident_name==""){
		alert("事故名称不能为空，请填写！");
		return true;
	}
	if(accident_type==""){
		alert("事故类型不能为空，请选择！");
		return true;
	}
	if(accident_level==""){
		alert("事故等级不能为空，请选择！");
		return true;
	}
	if(accident_date==""){
		alert("事故日期不能为空，请填写！");
		return true;
	}
	if(accident_place==""){
		alert("事故地点不能为空，请填写！");
		return true;
	}
	if(place_type==""){
		alert("地点类型不能为空，请填写！");
		return true;
	}
	if(bulletin_flag==""){
		alert("是否通报不能为空，请选择！");
		return true;
	}
	if(case_flag==""){
		alert("是否结案不能为空，请选择！");
		return true;
	}
	if(duty_flag==""){
		alert("是否责任事故不能为空，请选择！");
		return true;
	}
	if(case_flag=="1"){
		if(case_date==""){
			alert("结案日期不能为空，请填写！");
			return true;
		}
	}
	if(workplace_flag==""){
		alert("是否属于工作场所不能为空，请选择！");
		return true;
	}
	if(out_flag==""){
		alert("是否为承包商不能为空，请选择！");
		return true;
	}
	if(out_flag=="1"){
		if(out_name==""){
			alert("承包商名称不能为空，请填写！");
			return true;
		}
		if(out_type==""){
			alert("承包商类型不能为空，请选择！");
			return true;
		}
	}
	if(accident_course==""){
		alert("事故经过不能为空，请填写！");
		return true;
	}
	return false;
}

function checkText1(){
	var first_reason = document.getElementById("first_reason").value;
	var second_reason = document.getElementById("second_reason").value;
	var accident_step = document.getElementById("accident_step").value;
	var accident_test = document.getElementById("accident_test").value;
	var re = /^[0-9]+\.?[0-9]*$/;   //判断字符串是否为数字     //判断正整数 /^[1-9]+[0-9]*]*$/  

    
	if(first_reason==""){
		alert("直接原因不能为空，请填写！");
		return true;
	}
	if(second_reason==""){
		alert("间接原因不能为空，请填写！");
		return true;
	}
	if(accident_step==""){
		alert("防范措施不能为空，请填写！");
		return true;
	}
	if(accident_test==""){
		alert("验证结果不能为空，请填写！");
		return true;
	}
	return false;
}

function checkText2(){
	var re = /^[0-9]+\.?[0-9]*$/;   //判断字符串是否为数字     //判断正整数 /^[1-9]+[0-9]*]*$/  
	var number_toxic=document.getElementById("number_toxic").value;
	if(number_toxic!=""){
		if (!re.test(number_toxic))
		   {
		       alert("急性工业中毒人数请输入数字！");
		       return true;
		    }
	}
	for(var i=0;i<5;i++){
		var number_die=document.getElementById("number_die"+i).value;
		var number_harm = document.getElementById("number_harm"+i).value;
		var number_injure=document.getElementById("number_injure"+i).value;
		if(number_die!=""){
			if (!re.test(number_die))
			   {
			       alert("死亡人数请输入数字！");
			       return true;
			    }
		}
		if(number_harm!=""){
			if (!re.test(number_harm))
			   {
			       alert("重伤人数请输入数字！");
			       return true;
			    }
		}
		if(number_injure!=""){
			if (!re.test(number_injure))
			   {
			       alert("轻伤人数请输入数字！");
			       return true;
			    }
		}
	}
	return false;
}

function checkText3(){
	var money_lose = document.getElementById("money_lose").value;
	var other_lose=document.getElementById("other_lose").value;
	var all_lose=document.getElementById("all_lose").value;
	var lose_hours=document.getElementById("lose_hours").value;
	var re = /^[0-9]+\.?[0-9]*$/;   //判断字符串是否为数字     //判断正整数 /^[1-9]+[0-9]*]*$/  

    
	if(money_lose==""){
		alert("直接损失不能为空，请填写！");
		return true;
	}
	if (!re.test(money_lose))
	   {
	       alert("直接损失请输入数字！");
	       return true;
	    }
	if(other_lose==""){
		alert("其他损失不能为空，请填写！");
		return true;
	}
	if (!re.test(other_lose))
	   {
	       alert("其他损失请输入数字！");
	       return true;
	    }
	if(all_lose==""){
		alert("经济损失合计不能为空，请填写！");
		return true;
	}
	if (!re.test(all_lose))
	   {
	       alert("经济损失合计请输入数字！");
	       return true;
	    }
	if(lose_hours==""){
		alert("损失工时不能为空，请填写！");
		return true;
	}
	if (!re.test(lose_hours))
	   {
	       alert("损失工时请输入数字！");
	       return true;
	    }
	return false;
}



</script>
</html>
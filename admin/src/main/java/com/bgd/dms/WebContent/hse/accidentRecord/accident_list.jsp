<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.webapp.util.JcdpMVCUtil" %>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	ISrvMsg resultMsg = OMSMVCUtil.getResponseMsg(request);
	String isProject = request.getParameter("isProject");
	if(isProject==null||isProject.equals("")){
		isProject = resultMsg.getValue("isProject");
	}
	

%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" /> 
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/hse/js/hseCommon.js"></script>
<title>无标题文档</title>
</head>

<body style="background:#fff"  onload="refreshData()">
      	<div id="list_table">
			<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td class="ali_cdn_name">事故名称</td>
			    <td class="ali_cdn_input"><input id="accidentName" name="accidentName" type="text"/></td>
			    <td class="ali_query">
				    <span class="cx"><a href="#" onclick="simpleSearch()" title="JCDP_btn_query"></a></span>
			    </td>
			    <td class="ali_query">
				    <span class="qc"><a href="#" onclick="clearQueryText()" title="JCDP_btn_clear"></a></span>
				</td>
			    <td>&nbsp;</td>
			    <auth:ListButton functionId="" css="gl" event="onclick='toSearch()'" title="JCDP_btn_filter"></auth:ListButton>
			  </tr>
			</table>
			</td>
			    <td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
			  </tr>
			</table>
			</div>
			<div id="table_box">
			  <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">
			    <tr>
			      <td class="bt_info_odd" exp="<input type='checkbox' name='rdo_entity_id' value='{hse_accident_id},{flag}' id='rdo_entity_id_{hse_accident_id}' onclick='loadDataDetail();'/>" >选择</td>
			      <td class="bt_info_even" autoOrder="1">序号</td> 
			      <td class="bt_info_odd" exp="{second_org_name}">单位</td>
			      <td class="bt_info_even" exp="{third_org_name}">基层单位</td>
			      <td class="bt_info_odd" exp="{fourth_org_name}">下属单位</td>
			      <td class="bt_info_even" exp="{accident_name}">事故事件名称</td>
			      <td class="bt_info_odd" exp="{accident_date}">事故事件日期</td>
			      <td class="bt_info_even" exp="{accident_type}">事故事件类型</td>
			      <td class="bt_info_odd" exp="{accident_level}">事故等级</td>
			    </tr>
			  </table>
			</div>
			<div id="fenye_box"><table width="100%" border="0" cellspacing="0" cellpadding="0" id="fenye_box_table">
			  <tr>
			    <td align="right">第1/1页，共0条记录</td>
			    <td width="10">&nbsp;</td>
			    <td width="30"><img src="<%=contextPath%>/images/fenye_01.png" width="20" height="20" /></td>
			    <td width="30"><img src="<%=contextPath%>/images/fenye_02.png" width="20" height="20" /></td>
			    <td width="30"><img src="<%=contextPath%>/images/fenye_03.png" width="20" height="20" /></td>
			    <td width="30"><img src="<%=contextPath%>/images/fenye_04.png" width="20" height="20" /></td>
			    <td width="50">到 
			      <label>
			        <input type="text" name="textfield" id="textfield" style="width:20px;" />
			      </label></td>
			    <td align="left"><img src="<%=contextPath%>/images/fenye_go.png" width="22" height="22" /></td>
			  </tr>
			</table>
			</div>
			<div class="lashen" id="line"></div>
			
			<div id="property_box_1">
			<div id="tag-container_3">
			  <ul id="tags" class="tags">
			    <li class="selectTag" id="tag3_0"><a href="#" onclick="getTab3(0)">基本信息</a></li>
			    <li id="tag3_1"><a href="#" onclick="getTab3(1)">事故原因分析</a></li>
			    <li id="tag3_2"><a href="#" onclick="getTab3(2)">伤亡人员</a></li>
			    <li id="tag3_3"><a href="#" onclick="getTab3(3)">经济损失</a></li>
			    <li id="tag3_4"><a href="#" onclick="getTab3(4)">生态损失</a></li>
			    <li id="tag3_5"><a href="#" onclick="getTab3(5)">汇报情况</a></li>
			  </ul>
			</div>
			
			<div id="tab_box" class="tab_box">
			<input type="hidden" id="hse_accident_id" name="hse_accident_id"></input>
			<input type="hidden" id="hse_record_id" name="hse_record_id"></input>
				<div id="tab_box_content0" class="tab_box_content">
					<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
					  <tr>
						    <td class="inquire_item6">单位：</td>
					      	<td class="inquire_form6">
					      	<input type="hidden" id="second_org" name="second_org" class="input_width" />
					      	<input type="text" id="second_org2" name="second_org2" class="input_width" <%if(!JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)||!JcdpMVCUtil.hasPermission("F_HSE_ORG_002", request)||!JcdpMVCUtil.hasPermission("F_HSE_ORG_003", request)){ %> readonly="readonly"<%} %> onkeydown="return noEdit(event)"/>
					      	<%if(JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)&&JcdpMVCUtil.hasPermission("F_HSE_ORG_002", request)&&JcdpMVCUtil.hasPermission("F_HSE_ORG_003", request)){ %>
					      	<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="selectOrg()"/>
					      	<%} %>
					      	</td>
					     	<td class="inquire_item6">基层单位：</td>
					      	<td class="inquire_form6">
					      	<input type="hidden" id="third_org" name="third_org" class="input_width" />
					      	<input type="text" id="third_org2" name="third_org2" class="input_width"  <%if(!JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)||!JcdpMVCUtil.hasPermission("F_HSE_ORG_002", request)){ %>readonly="readonly"<%} %> onkeydown="return noEdit(event)"/>
					      	<%if(JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)&&JcdpMVCUtil.hasPermission("F_HSE_ORG_002", request)){ %>
					      	<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="selectOrg2()"/>
					      	<%} %>
					      	</td>
					      	<td class="inquire_item6">下属单位：</td>
					      	<td class="inquire_form6">
					      	<input type="hidden" id="fourth_org" name="fourth_org" class="input_width" />
					      	<input type="text" id="fourth_org2" name="fourth_org2" class="input_width"  <%if(!JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)){ %>readonly="readonly"<%} %> onkeydown="return noEdit(event)"/>
					      	<%if(JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)){ %>
					      	<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="selectOrg3()"/>
					      	<%}%>
					      	</td>
					  </tr>
					  <tr>
					    <td class="inquire_item6">事故名称：</td>
					    <td class="inquire_form6"><input type="text" id="accident_name" name="accident_name" class="input_width" /></td>
					    <td class="inquire_item6">事故类型：</td>
					    <td class="inquire_form6">
					    	<select id="accident_type" name="accident_type" class="select_width">
					          <option value="" >请选择</option>
					          <option value="1" >工业生产安全事故</option>
					          <option value="2" >火灾事故</option>
					          <option value="3" >交通事故</option>
						    </select>
						</td>
					    <td class="inquire_item6">事故日期：</td>
					    <td class="inquire_form6"><input type="text" id="accident_date" name="accident_date" class="input_width" readonly="readonly"/>
					    </td>
					  </tr>	
					  <tr>
					   <td class="inquire_item6">事故等级：</td>
					    <td class="inquire_form6">
					    	<select id="accident_level" name="accident_level" class="select_width">
					          <option value="" >请选择</option>
					          <option value="1" >一般</option>
					          <option value="2" >较大</option>
					          <option value="3" >重大</option>
					          <option value="4" >特大</option>
						    </select>
					  </td>
					    <td class="inquire_item6">事故地点：</td>
					    <td class="inquire_form6"><input type="text" id="accident_place" name="accident_place" class="input_width"/></td>
					    <td class="inquire_item6">地点类型：</td>
					    <td class="inquire_form6"><input type="text" id="place_type" name="place_type" class="input_width"/></td>
					  </tr>	
					  <tr>
					    <td class="inquire_item6">是否通报：</td>
					    <td class="inquire_form6">
						<select id="bulletin_flag" name="bulletin_flag" class="select_width">
					       <option value="" >请选择</option>
					       <option value="1" >是</option>
					       <option value="0" >否</option>
						</select>
					    </td>
					    <td class="inquire_item6">是否结案：</td>
					    <td class="inquire_form6">
						<select id="case_flag" name="case_flag" class="select_width" >
					       <option value="" >请选择</option>
					       <option value="1" >是</option>
					       <option value="0" >否</option>
						</select>
						</td>
					    <td class="inquire_item6">是否责任事故：</td>
					    <td class="inquire_form6">
						<select id="duty_flag" name="duty_flag" class="select_width">
					       <option value="" >请选择</option>
					       <option value="1" >是</option>
					       <option value="0" >否</option>
						</select>
					    </td>
					 	</td>
					  </tr>
					  <tr>
					    <td class="inquire_item6">结案日期：</td>
					    <td class="inquire_form6"><input type="text" id="case_date" name="case_date" class="input_width"  readonly="readonly"/>
					  <td class="inquire_item6">是否属于工作场所：</td>
					    <td class="inquire_form6">
						<select id="workplace_flag" name="workplace_flag" class="select_width">
					       <option value="" >请选择</option>
					       <option value="1" >是</option>
					       <option value="0" >否</option>
						</select>
					    </td>
					    <td class="inquire_item6">是否为承包商：</td>
					    <td class="inquire_form6">
						<select id="out_flag" name="out_flag" class="select_width">
					       <option value="" >请选择</option>
					       <option value="1" >是</option>
					       <option value="0" >否</option>
						</select>
						</td>
					  </tr>
					  <tr>
					  	<td class="inquire_item6">承包商名称：</td>
					    <td class="inquire_form6"><input type="text" id="out_name" name="out_name" class="input_width"  /></td>
					    <td class="inquire_item6">承包商类型：</td>
					    <td class="inquire_form6">
					    <select id="out_type" name="out_type" class="select_width">
					       <option value="" >请选择</option>
					       <option value="1" >集团内</option>
					       <option value="0" >集团外</option>
						</select>
					    </td>
					    <td class="inquire_item6"></td>
					    <td class="inquire_item6"></td>
					  </tr>	
					  <tr>
					    <td class="inquire_item6">事故经过：</td>
					    <td class="inquire_form6" colspan="5"><textarea id="accident_course" name="accident_course"   class="textarea" ></textarea></td>
					  </tr>	
					</table>
				</div>
				<div id="tab_box_content1" class="tab_box_content" style="display:none;">
					<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
					  <tr>
					    <td class="inquire_item6">风险消减情况：</td>
					    <td class="inquire_form6"><input type="text" id="accident_risk" name="accident_risk" class="input_width" /></td>
					    <td class="inquire_item6"></td>
					    <td class="inquire_form6"></td>
					    <td class="inquire_form6"></td>
					    <td class="inquire_form6"></td>
					  </tr>
					  <tr>
					    <td class="inquire_item6">直接原因:</td>
					    <td class="inquire_form6" colspan="5"><textarea id="first_reason" name="first_reason"   class="textarea" ></textarea></td>
					  </tr>	
					  <tr>
					    <td class="inquire_item6">间接原因:</td>
					    <td class="inquire_form6" colspan="5"><textarea id="second_reason" name="second_reason"   class="textarea" ></textarea></td>
					  </tr>	
					  <tr>
					    <td class="inquire_item6">防范措施：</td>
					    <td class="inquire_form6" colspan="5"><textarea id="accident_step" name="accident_step"   class="textarea" ></textarea></td>
					  </tr>	
					  <tr>
					    <td class="inquire_item6">验证结果：</td>
					    <td class="inquire_form6" colspan="5"><textarea id="accident_test" name="accident_test"   class="textarea" ></textarea></td>
					  </tr>	
					  <tr>
					    <td class="inquire_item6">备注：</td>
					    <td class="inquire_form6" colspan="5"><textarea id="accident_note" name="accident_note"   class="textarea" ></textarea></td>
					  </tr>	
					</table>
				</div>
				<div id="tab_box_content2" class="tab_box_content" style="display:none;">
					<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
						<tr >
					        <td align="center">急性工业中毒：</td>
					        <td ><input type="text" id="number_toxic" name="number_toxic" class="input_width" /></td>
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
				        	<td ><input type="text" id="number_die0" name="number_die0" class="input_width" onchange="allDie()"/></input></td>
				        	<td ><input type="text" id="number_harm0" name="number_harm0" class="input_width"  onchange="allHarm()"/></td>
				        	<td ><input type="text" id="number_injure0" name="number_injure0" class="input_width"  onchange="allInjure()"/></td>
				        </tr>
				         <tr class="even">
				        	<td >外部承包商</td>
				        	<td ><input type="text" id="number_die1" name="number_die1" class="input_width"  onchange="allDie()"/></input></td>
				        	<td ><input type="text" id="number_harm1" name="number_harm1" class="input_width"  onchange="allHarm()"/></td>
				        	<td ><input type="text" id="number_injure1" name="number_injure1" class="input_width"  onchange="allInjure()"/></td>
				        </tr>
				         <tr class="odd">
				        	<td >股份承包商</td>
				        	<td ><input type="text" id="number_die2" name="number_die2" class="input_width"  onchange="allDie()"/></input></td>
				        	<td ><input type="text" id="number_harm2" name="number_harm2" class="input_width"  onchange="allHarm()"/></td>
				        	<td ><input type="text" id="number_injure2" name="number_injure2" class="input_width"  onchange="allInjure()"/></td>
				        </tr>
				         <tr class="even">
				        	<td >集团承包商</td>
				        	<td ><input type="text" id="number_die3" name="number_die3" class="input_width"  onchange="allDie()"/></input></td>
				        	<td ><input type="text" id="number_harm3" name="number_harm3" class="input_width"  onchange="allHarm()"/></td>
				        	<td ><input type="text" id="number_injure3" name="number_injure3" class="input_width"  onchange="allInjure()"/></td>
				        </tr>
				         <tr class="odd">
				        	<td >第三方</td>
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
				<div id="tab_box_content3" class="tab_box_content"  style="display:none;">
					<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
					  <tr>
						  <td class="inquire_item6">直接损失：</td>
				      	  <td class="inquire_form6">
				      	  <input type="text" id="money_lose" name="money_lose" class="input_width"/>
				      	  </td>
				      	  <td class="inquire_item6">其他损失：</td>
					      	<td class="inquire_form6">
					      	<input type="text" id="other_lose" name="other_lose" class="input_width"/>
					      	</td>
					    <td class="inquire_item6">经济损失合计：</td>
					    <td class="inquire_form6"><input type="text" id="all_lose" name="all_lose" class="input_width" /></td>
					  </tr>
					  <tr>
					    <td class="inquire_item6">损失工时：</td>
					    <td class="inquire_form6"><input type="text" id="lose_hours" name="lose_hours" class="input_width" /></td>
					    <td class="inquire_item6"></td>
					    <td class="inquire_item6"></td>
					    <td class="inquire_item6"></td>
					    <td class="inquire_item6"></td>
					  </tr>	
					</table>
				</div>
				<div id="tab_box_content4" class="tab_box_content"  style="display:none;">
					<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
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
				<div id="tab_box_content5" class="tab_box_content"  style="display:none;">
					<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
					  <tr>
				      	<td class="inquire_item6">事故报告时间：</td>
					    <td class="inquire_form6"><input type="text" id="report_date" name="report_date" class="input_width" readonly="readonly"/>
					    </td>
				      	  <td class="inquire_item6">报告人：</td>
					      	<td class="inquire_form6">
					      	<input type="text" id="report_name" name="report_name" class="input_width"/>
					      	</td>
					    <td class="inquire_item6">联系人：</td>
					    <td class="inquire_form6"><input type="text" id="contact_name" name="contact_name" class="input_width" /></td>
					  </tr>
					  <tr>
					    <td class="inquire_item6">电话：</td>
					    <td class="inquire_form6"><input type="text" id="phone" name="phone" class="input_width" /></td>
					    <td class="inquire_item6">填表日期：</td>
					    <td class="inquire_form6"><input type="text" id="table_date" name="table_date" class="input_width" readonly="readonly"/>
					   </td>
					    <td class="inquire_item6">填表人：</td>
					    <td class="inquire_form6"><input type="text" id="table_person" name="table_person" class="input_width" /></td>
					  </tr>
					  <tr>
					    <td class="inquire_item6">责任追究情况：</td>
					    <td class="inquire_form6"><input type="text" id="duty_id" name="duty_id" class="input_width" /></td>
					    <td class="inquire_item6">其他损失情况：</td>
					    <td class="inquire_form6"><input type="text" id="lose_id" name="lose_id" class="input_width" /></td>
					    <td class="inquire_item6">事故材料：</td>
					    <td class="inquire_form6"><input type="text" id="stuff_id" name="stuff_id" class="input_width" /></td>
					  </tr>
					</table>
				</div>
			</div>
			</div>
		
			<div id="property_box_2" style="display: none;">
			<div id="tag-container_3">
			  <ul id="tags" class="tags">
			    <li class="selectTag" id="tag33_0"><a href="#" onclick="getTab33(0)">基本信息</a></li>
			    <li id="tag33_1"><a href="#" onclick="getTab33(1)">受伤害人员</a></li>
			    <li id="tag33_2"><a href="#" onclick="getTab33(2)">事件分析</a></li>
			    <li id="tag33_3"><a href="#" onclick="getTab33(3)">经济损失</a></li>
			  </ul>
			</div>
			
			<div id="tab_box" class="tab_box">
			<input type="hidden" id="hse_event_id" name="hse_event_id"></input>
				<div id="tab_box_content330" class="tab_box_content">
					<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
					  <tr>
						  <td class="inquire_item6">单位：</td>
					      	<td class="inquire_form6">
					      	<input type="hidden" id="second_org33" name="second_org33" class="input_width" />
					      	<input type="text" id="second_org332" name="second_org332" class="input_width" <%if(!JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)||!JcdpMVCUtil.hasPermission("F_HSE_ORG_002", request)||!JcdpMVCUtil.hasPermission("F_HSE_ORG_003", request)){ %> readonly="readonly"<%} %> onkeydown="return noEdit(event)"/>
					      	<%if(JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)&&JcdpMVCUtil.hasPermission("F_HSE_ORG_002", request)&&JcdpMVCUtil.hasPermission("F_HSE_ORG_003", request)){ %>
					      	<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="selectOrg()"/>
					      	<%} %>
					      	</td>
					     	<td class="inquire_item6">基层单位：</td>
					      	<td class="inquire_form6">
					      	<input type="hidden" id="third_org33" name="third_org33" class="input_width" />
					      	<input type="text" id="third_org332" name="third_org332" class="input_width"  <%if(!JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)||!JcdpMVCUtil.hasPermission("F_HSE_ORG_002", request)){ %>readonly="readonly"<%} %> onkeydown="return noEdit(event)"/>
					      	<%if(JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)&&JcdpMVCUtil.hasPermission("F_HSE_ORG_002", request)){ %>
					      	<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="selectOrg2()"/>
					      	<%} %>
					      	</td>
					      	<td class="inquire_item6">下属单位：</td>
					      	<td class="inquire_form6">
					      	<input type="hidden" id="fourth_org33" name="fourth_org33" class="input_width" />
					      	<input type="text" id="fourth_org332" name="fourth_org332" class="input_width"  <%if(!JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)){ %>readonly="readonly"<%} %> onkeydown="return noEdit(event)"/>
					      	<%if(JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)){ %>
					      	<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="selectOrg3()"/>
					      	<%}%>
					      	</td>
					  </tr>
					  <tr>
					    <td class="inquire_item6">事件名称：</td>
					    <td class="inquire_form6"><input type="text" id="event_name" name="event_name" class="input_width" /></td>
					    <td class="inquire_item6">事件类型：</td>
					    <td class="inquire_form6">
					    	<select id="event_type" name="event_type" class="select_width">
					          <option value="" >请选择</option>
					          <option value="1" >工业生产安全事件</option>
					          <option value="2" >火灾事件</option>
					          <option value="3" >道路交通事件</option>
					          <option value="4" >其他事件</option>
						    </select>
						</td>
					    <td class="inquire_item6">事件日期：</td>
					    <td class="inquire_form6"><input type="text" id="event_date" name="event_date" class="input_width" readonly="readonly"/>
					    </td>
					  </tr>	
					  <tr>
					   <td class="inquire_item6">事件性质：</td>
					    <td class="inquire_form6">
							<select id="event_property" name="event_property" class="select_width">
					          <option value="" >请选择</option>
					          <option value="1" >限工事件</option>
					          <option value="2" >医疗事件</option>
					          <option value="3" >急救箱事件</option>
					          <option value="4" >经济损失事件</option>
					          <option value="5" >未遂事件</option>
						    </select>
					    </td>
					    <td class="inquire_item6">事件地点：</td>
					    <td class="inquire_form6"><input type="text" id="event_place" name="event_place" class="input_width" /></td>
					    <td class="inquire_item6">填报日期：</td>
					    <td class="inquire_form6"><input type="text" id="write_date" name="write_date" class="input_width" readonly="readonly"/>
					    </td>
					  </tr>
					  <tr>
					  <td class="inquire_item6">是否为承包商：</td>
					    <td class="inquire_form6">
						<select id="out_flag33" name="out_flag33" class="select_width" >
					       <option value="" >请选择</option>
					       <option value="1" >是</option>
					       <option value="0" >否</option>
						</select>
						</td>
					    <td class="inquire_item6">承包商名称：</td>
					    <td class="inquire_form6"><input type="text" id="out_name33" name="out_name33" class="input_width" value=""/></td>
					   <td class="inquire_item6">报告人：</td>
					    <td class="inquire_form6"><input type="text" id="report_name" name="report_name" class="input_width" value=""/></td>
					  </tr>	
					  <tr>
					    <td class="inquire_item6">报告时间：</td>
					    <td class="inquire_form6"><input type="text" id="report_date" name="report_date" class="input_width" value="" readonly="readonly"/></td>
					    <td class="inquire_item6"></td>
					    <td class="inquire_form6"></td>
					    <td class="inquire_item6"></td>
					    <td class="inquire_form6"></td>
					  </tr>
					</table>
				</div>
				<div id="tab_box_content331" class="tab_box_content" style="display:none;">
					<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
					  <tr>
					    <td class="inquire_item6">本企业伤害人数：</td>
					    <td class="inquire_form6"><input type="text" id="number_owner" name="number_owner" class="input_width" /></td>
					    <td class="inquire_item6">外部承包商伤害人数：</td>
					    <td class="inquire_form6"><input type="text" id="number_out" name="number_out" class="input_width" /></td>
					    <td class="inquire_item6">股份承包商伤害人数：</td>
					    <td class="inquire_form6"><input type="text" id="number_stock" name="number_stock" class="input_width" /></td>
					  </tr>
					  <tr>
					    <td class="inquire_item6">集团承包商伤害人数：</td>
					    <td class="inquire_form6"><input type="text" id="number_group" name="number_group" class="input_width" /></td>
					    <td class="inquire_item6">限工工时：</td>
					    <td class="inquire_form6"><input type="text" id="number_hours" name="number_hours" class="input_width" /></td>
					    <td class="inquire_item6"></td>
					    <td class="inquire_form6"></td>
					  </tr>	
					</table>
				</div>
				<div id="tab_box_content332" class="tab_box_content" style="display:none;">
					<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
					  <tr>
					    <td class="inquire_item6">事件原因分析人：</td>
					    <td class="inquire_form6"><input type="text" id="analyze_name" name="analyze_name" class="input_width" /></td>
					    <td class="inquire_item6">分析人所在单位：</td>
					    <td class="inquire_form6"><input type="text" id="analyze_work" name="analyze_work" class="input_width" /></td>
					    <td class="inquire_item6">纠正预防措施完成时间：</td>
					    <td class="inquire_form6"><input type="text" id="result_date" name="result_date" class="input_width" readonly="readonly"/>
					   </td>
					  </tr>	
					  <tr>
					    <td class="inquire_item6">责任人：</td>
					    <td class="inquire_form6"><input type="text" id="duty_name" name="duty_name" class="input_width" /></td>
					    <td class="inquire_item6"></td>
					    <td class="inquire_item6"></td>
					    <td class="inquire_item6"></td>
					    <td class="inquire_item6"></td>
					  </tr>	
					  <tr>
					    <td class="inquire_item6">事件经过描述：</td>
					    <td class="inquire_form6" colspan="5"><textarea id="event_process" name="event_process" class="textarea" ></textarea></td>
					  </tr>	
					  <tr>
					    <td class="inquire_item6">事件原因：</td>
					    <td class="inquire_form6" colspan="5"><textarea id="event_reason" name="event_reason"   class="textarea" ></textarea></td>
					  </tr>	
					  <tr>
					    <td class="inquire_item6">事件原因描述：</td>
					    <td class="inquire_form6" colspan="5"><textarea id="event_describe" name="event_describe"  class="textarea"  ></textarea></td>
					  </tr>	
					  <tr>
					    <td class="inquire_item6">采取纠正预防措施：</td>
					    <td class="inquire_form6" colspan="5"><textarea id="event_result" name="event_result"  class="textarea"  ></textarea></td>
					  </tr>	 
					</table>
				</div>
				<div id="tab_box_content333" class="tab_box_content" style="display:none;">
					<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
					  <tr>
					    <td class="inquire_item6">直接经济损失：</td>
					    <td class="inquire_form6"><input type="text" id="first_money" name="first_money" class="input_width"  />元</td>
					    <td class="inquire_item6">间接经济损失：</td>
					    <td class="inquire_form6"><input type="text" id="second_money" name="second_money" class="input_width"  />元</td>
					    <td class="inquire_item6">经济损失合计：</td>
					    <td class="inquire_form6"><input type="text" id="all_money" name="all_money" class="input_width" readonly="readonly"/>元</td>
					  </tr>
					</table>
				</div>
			</div>
		</div>
	</div>
</body>
<script type="text/javascript">
function frameSize(){
	//$("#tab_box").children("div").css("height",$(window).height()-$("#inq_tool_box").height()-$("#table_box").height()-$("#fenye_box").height()-$("#line").height()-$("#tag-container_3").height());
	setTabBoxHeight();
}
frameSize();


$(function(){
	$(window).resize(function(){
  		frameSize();
	});
})	

$(document).ready(lashen);
</script>

<script type="text/javascript">


	cruConfig.contextPath =  "<%=contextPath%>";
	
	// 复杂查询
	function refreshData(){
		var isProject = "<%=isProject%>";
		var sql = "";
		if(isProject=="1"){
			sql = getMultipleSql();
		}else if(isProject=="2"){
			sql = "and t.project_info_no='<%=user.getProjectInfoNo()%>'";
		}
		cruConfig.cdtType = 'form';
		debugger;
		cruConfig.queryStr = "select t.*,oi1.org_abbreviation as second_org_name,oi2.org_abbreviation as third_org_name,oi3.org_abbreviation as fourth_org_name from ((select n.hse_accident_id, second_org,third_org,fourth_org,accident_name,accident_date,decode(accident_type,'1','工业生产安全事故','2','火灾事故','3','交通事故') as accident_type,decode(r.accident_level,'1','一般','2','较大','3','重大','4','特大') as accident_level,n.modifi_date,1 flag,n.project_info_no,n.bsflag from bgp_hse_accident_news n left join bgp_hse_accident_record r on n.hse_accident_id = r.hse_accident_id and r.bsflag = '0' where n.bsflag = '0') union all (select hse_event_id,second_org,third_org,fourth_org,event_name,event_date,decode(event_type,'1','工业生产安全事件','2','火灾事件','3','道路交通事件','4','其他事件') as event_type,null,modifi_date,2 flag,project_info_no,bsflag from bgp_hse_event e where e.bsflag='0')) t left  join comm_org_subjection os1 on t.second_org = os1.org_subjection_id and os1.bsflag = '0' left join comm_org_information oi1 on oi1.org_id = os1.org_id and oi1.bsflag = '0' left join comm_org_subjection os2 on t.third_org = os2.org_subjection_id and os2.bsflag = '0' left join comm_org_information oi2 on oi2.org_id = os2.org_id and oi2.bsflag = '0' left join comm_org_subjection os3 on t.fourth_org = os3.org_subjection_id and os3.bsflag = '0' left join comm_org_information oi3 on oi3.org_id = os3.org_id and oi3.bsflag = '0' where t.bsflag='0' "+sql+" order by t.modifi_date desc";
		cruConfig.currentPageUrl = "/hse/accidentRecord/accident_list.jsp";
		queryData(1);
	}
	
	function refreshData2(sql){
		cruConfig.cdtType = 'form';
		cruConfig.queryStr = sql;
		cruConfig.currentPageUrl = "/hse/accidentRecord/accident_list.jsp";
		queryData(1);
	}
	
	// 简单查询
	function simpleSearch(){
		var isProject = "<%=isProject%>";
		var sql = "";
		if(isProject=="1"){
			sql = getMultipleSql();
		}else if(isProject=="2"){
			sql = "and t.project_info_no='<%=user.getProjectInfoNo()%>'";
		}
		var accidentName = document.getElementById("accidentName").value;
			if(accidentName!=''&&accidentName!=null){
				cruConfig.cdtType = 'form';
				cruConfig.queryStr = "select t.*,oi1.org_abbreviation as second_org_name,oi2.org_abbreviation as third_org_name,oi3.org_abbreviation as fourth_org_name from ((select n.hse_accident_id, second_org,third_org,fourth_org,accident_name,accident_date,decode(accident_type,'1','工业生产安全事故','2','火灾事故','3','交通事故') as accident_type,decode(r.accident_level,'1','一般','2','较大','3','重大','4','特大') as accident_level,n.modifi_date,1 flag,n.project_info_no,n.bsflag from bgp_hse_accident_news n left join bgp_hse_accident_record r on n.hse_accident_id = r.hse_accident_id and r.bsflag = '0' where n.bsflag = '0') union all (select hse_event_id,second_org,third_org,fourth_org,event_name,event_date,decode(event_type,'1','工业生产安全事件','2','火灾事件','3','道路交通事件','4','其他事件') as event_type,null,modifi_date,2 flag,project_info_no,bsflag from bgp_hse_event e where e.bsflag='0')) t left  join comm_org_subjection os1 on t.second_org = os1.org_subjection_id and os1.bsflag = '0' left join comm_org_information oi1 on oi1.org_id = os1.org_id and oi1.bsflag = '0' left join comm_org_subjection os2 on t.third_org = os2.org_subjection_id and os2.bsflag = '0' left join comm_org_information oi2 on oi2.org_id = os2.org_id and oi2.bsflag = '0' left join comm_org_subjection os3 on t.fourth_org = os3.org_subjection_id and os3.bsflag = '0' left join comm_org_information oi3 on oi3.org_id = os3.org_id and oi3.bsflag = '0' where t.bsflag='0' "+sql+" and accident_name like '%"+accidentName+"%' order by t.modifi_date desc";
				cruConfig.currentPageUrl = "/hse/accidentRecord/accident_list.jsp";
				queryData(1);
			}else{
				refreshData();
			}
	}
	
	function clearQueryText(){
		document.getElementById("accidentName").value = "";
	}
	
	function loadDataDetail(shuaId){
		debugger;
		var id;
		var flag ;
		var retObj;
		if(shuaId!=null){
			var temp = shuaId.split(',');
			var id = temp[0];
			var flag = temp[1];
		}else{
			var ids = getSelIds('rdo_entity_id');
		    if(ids==''){ 
			    alert("请先选中一条记录!");
	     		return;
		    }
		    var temps = ids.split(',');
		    id = temps[0];
		    flag = temps[1];
		}
		if(flag=="1"){
			document.getElementById("property_box_1").style.display="";
			document.getElementById("property_box_2").style.display="none";
		retObj = jcdpCallService("HseSrv", "viewRecord", "hse_accident_id="+id);
		document.getElementById("hse_accident_id").value =retObj.map.hseAccidentId;
		document.getElementById("hse_record_id").value =retObj.map.hseRecordId;
		document.getElementById("second_org").value =retObj.map.secondOrg;
		document.getElementById("third_org").value =retObj.map.thirdOrg;
		document.getElementById("fourth_org").value =retObj.map.fourthOrg;
		document.getElementById("second_org2").value =retObj.map.secondOrgName;
		document.getElementById("third_org2").value =retObj.map.thirdOrgName;
		document.getElementById("fourth_org2").value =retObj.map.fourthOrgName;
		document.getElementById("accident_name").value =retObj.map.accidentName;
		document.getElementById("accident_type").value = retObj.map.accidentType;
		document.getElementById("accident_level").value = retObj.map.accidentLevel;
		document.getElementById("accident_date").value = retObj.map.accidentDate;
		document.getElementById("accident_place").value = retObj.map.accidentPlace;
		document.getElementById("place_type").value = retObj.map.placeType;
		document.getElementById("bulletin_flag").value = retObj.map.bulletinFlag;
		document.getElementById("case_flag").value = retObj.map.caseFlag;
		document.getElementById("case_date").value = retObj.map.caseDate;
		document.getElementById("duty_flag").value = retObj.map.dutyFlag;
		document.getElementById("workplace_flag").value = retObj.map.workplaceFlag;
		document.getElementById("out_flag").value = retObj.map.outFlag;
		document.getElementById("out_type").value = retObj.map.outType;
		document.getElementById("out_name").value = retObj.map.outName;
		document.getElementById("accident_course").value = retObj.map.accidentCourse;
		
		document.getElementById("first_reason").value = retObj.map.firstReason;
		document.getElementById("second_reason").value = retObj.map.secondReason;
		document.getElementById("accident_note").value = retObj.map.accidentNote;
		document.getElementById("accident_step").value = retObj.map.accidentStep;
		document.getElementById("accident_test").value = retObj.map.accidentTest;
		document.getElementById("accident_risk").value = retObj.map.accidentRisk;
		
		
		document.getElementById("money_lose").value = retObj.map.moneyLose;
		document.getElementById("other_lose").value = retObj.map.otherLose;
		document.getElementById("all_lose").value = retObj.map.allLose;
		document.getElementById("lose_hours").value = retObj.map.loseHours;
		
		document.getElementById("report_date").value = retObj.map.reportDate;
		document.getElementById("report_name").value = retObj.map.reportName;
		document.getElementById("contact_name").value = retObj.map.contactName;
		document.getElementById("phone").value = retObj.map.phone;
		document.getElementById("table_date").value = retObj.map.tableDate;
		document.getElementById("table_person").value = retObj.map.tablePerson;
		document.getElementById("duty_id").value = retObj.map.dutyId;
		document.getElementById("lose_id").value = retObj.map.loseId;
		document.getElementById("stuff_id").value = retObj.map.stuffId;
		document.getElementById("number_toxic").value = retObj.map.numberToxic;
		
		
		document.getElementById("selected1").checked = false;
		document.getElementById("selected2").checked = false;
		document.getElementById("selected3").checked = false;
		document.getElementById("selected4").checked = false;
		var pollution_type = retObj.map.pollutionType;
		var selected = document.getElementsByName("selected");
		if(pollution_type!=null&&pollution_type!=""){
			var temp = pollution_type.split(",");
			for(var j=0;j<temp.length;j++){
				document.getElementById("selected"+temp[j]).checked = true;
			}
		}
		
		for(var j =1;j <document.getElementById("lineTable")!=null && j < document.getElementById("lineTable").rows.length ;){
			document.getElementById("lineTable").deleteRow(j);
		}
		
		for(var i=0;i<retObj.list3.length;i++){
			toAddLine(
					retObj.list3[i].hseEnvironmentId ? retObj.list3[i].hseEnvironmentId : "",
					retObj.list3[i].leakName ? retObj.list3[i].leakName : "",
					retObj.list3[i].leakNum ? retObj.list3[i].leakNum : "",
					retObj.list3[i].emissionNum ? retObj.list3[i].emissionNum : "",
					retObj.list3[i].equalNum ? retObj.list3[i].equalNum : "",
					retObj.list3[i].casId ? retObj.list3[i].casId : ""
				);
		}
		
		
		var die = 0;
		var harm =0;
		var injure = 0;
		for(var i=0;i<5;i++){
			if(retObj.list!=null){
			var qwe = retObj.list[i];
				document.getElementById("number_die"+i).value = retObj.list[i].numberDie;
				document.getElementById("number_harm"+i).value = retObj.list[i].numberHarm;
				document.getElementById("number_injure"+i).value = retObj.list[i].numberInjure;
			}else{
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
		}else if(flag=="2"){
			document.getElementById("property_box_1").style.display="none";
			document.getElementById("property_box_2").style.display="";
			retObj = jcdpCallService("HseSrv", "viewEvent", "hse_event_id="+id);
			
			document.getElementById("hse_event_id").value =retObj.map.hseEventId;
			document.getElementById("second_org33").value =retObj.map.secondOrg;
			document.getElementById("third_org33").value =retObj.map.thirdOrg;
			document.getElementById("fourth_org33").value =retObj.map.fourthOrg;
			document.getElementById("second_org332").value =retObj.map.secondOrgName;
			document.getElementById("third_org332").value =retObj.map.thirdOrgName;
			document.getElementById("fourth_org332").value =retObj.map.fourthOrgName;
			document.getElementById("event_name").value =retObj.map.eventName;
			document.getElementById("event_type").value = retObj.map.eventType;
			document.getElementById("event_property").value = retObj.map.eventProperty;
			document.getElementById("event_date").value = retObj.map.eventDate;
			document.getElementById("event_place").value = retObj.map.eventPlace;
			document.getElementById("write_date").value = retObj.map.writeDate;
			document.getElementById("out_flag33").value = retObj.map.outFlag;
			document.getElementById("out_name33").value = retObj.map.outName;
			document.getElementById("report_name").value = retObj.map.reportName;
			document.getElementById("report_date").value = retObj.map.reportDate;
			
			document.getElementById("number_owner").value = retObj.map.numberOwner;
			document.getElementById("number_out").value = retObj.map.numberOut;
			document.getElementById("number_stock").value = retObj.map.numberStock;
			document.getElementById("number_group").value = retObj.map.numberGroup;
			document.getElementById("number_hours").value = retObj.map.numberHours;
			
			document.getElementById("event_process").value = retObj.map.eventProcess;
			document.getElementById("event_reason").value = retObj.map.eventReason;
			document.getElementById("event_result").value = retObj.map.eventResult;
			document.getElementById("event_describe").value = retObj.map.eventDescribe;
			document.getElementById("analyze_name").value = retObj.map.analyzeName;
			document.getElementById("analyze_work").value = retObj.map.analyzeWork;
			document.getElementById("result_date").value = retObj.map.resultDate;
			document.getElementById("duty_name").value = retObj.map.dutyName;
			
			document.getElementById("first_money").value = retObj.map.firstMoney;
			document.getElementById("second_money").value = retObj.map.secondMoney;
			document.getElementById("all_money").value = retObj.map.allMoney;
		}
	}

	var selectedTagIndex = 0;//document.getElementById("tag3_0").parentElement;
	var showTabBox = document.getElementById("tab_box_content0");
	var selectedTagIndex33 = 0;//document.getElementById("tag3_0").parentElement;
	var showTabBox33 = document.getElementById("tab_box_content0");
	
	function getTab33(index) {  
		var selectedTag33 = document.getElementById("tag33_"+selectedTagIndex33);
		var selectedTabBox33 = document.getElementById("tab_box_content33"+selectedTagIndex33)
		selectedTag33.className ="";
		selectedTabBox33.style.display="none";

		selectedTagIndex33 = index;
		
		selectedTag33 = document.getElementById("tag33_"+selectedTagIndex33);
		selectedTabBox33 = document.getElementById("tab_box_content33"+selectedTagIndex33)
		selectedTag33.className ="selectTag";
		selectedTabBox33.style.display="block";
	}
	
	function toSearch(){
		popWindow("<%=contextPath%>/hse/accidentRecord/accident_search.jsp?isProject=<%=isProject%>");
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
		
//		if(hse_dan_ids!="") hse_dan_ids += ",";
//		hse_dan_ids += hse_dan_id; 
	}
</script>

</html>


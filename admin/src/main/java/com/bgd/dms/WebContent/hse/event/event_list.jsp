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
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
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
			    <td class="ali_cdn_input"><input id="eventName" name="eventName" type="text" /></td>
			    <td class="ali_query">
				    <span class="cx"><a href="#" onclick="simpleSearch()" title="JCDP_btn_query"></a></span>
			    </td>
			    <td class="ali_query">
				    <span class="qc"><a href="#" onclick="clearQueryText()" title="JCDP_btn_clear"></a></span>
				</td>
			    <td>&nbsp;</td>
			    <auth:ListButton functionId="" css="gl" event="onclick='toSearch()'" title="JCDP_btn_filter"></auth:ListButton>
			    <auth:ListButton functionId="F_HSE_AUTH_001,F_HSE_AUTH_002" css="zj" event="onclick='toAdd()'" title="JCDP_btn_add"></auth:ListButton>
			    <auth:ListButton functionId="F_HSE_AUTH_001,F_HSE_AUTH_002" css="xg" event="onclick='toEdit()'" title="JCDP_btn_edit"></auth:ListButton>
			    <auth:ListButton functionId="F_HSE_AUTH_001,F_HSE_AUTH_002" css="sc" event="onclick='toDelete()'" title="JCDP_btn_delete"></auth:ListButton>
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
			      <td class="bt_info_odd" exp="<input type='checkbox' name='rdo_entity_id' value='{hse_event_id}' id='rdo_entity_id_{hse_enent_id}' onclick='loadDataDetail();'/>" >选择</td>
			      <td class="bt_info_even" autoOrder="1">序号</td> 
			      <td class="bt_info_odd" exp="{second_org_name}">单位</td>
			      <td class="bt_info_even" exp="{third_org_name}">基层单位</td>
			      <td class="bt_info_odd" exp="{fourth_org_name}">下属单位</td>
			      <td class="bt_info_even" exp="{event_name}">事件名称</td>
			      <td class="bt_info_odd" exp="{event_type}">事件类型</td>
			      <td class="bt_info_even" exp="{event_property}">事件性质</td>
			      <td class="bt_info_odd" exp="{event_date}">事件日期</td>
			      <td class="bt_info_even" exp="{event_place}">事件地点</td>
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
			<div id="tag-container_3">
			  <ul id="tags" class="tags">
			    <li class="selectTag" id="tag3_0"><a href="#" onclick="getTab3(0)">基本信息</a></li>
			    <li id="tag3_1"><a href="#" onclick="getTab3(1)">受伤害人员</a></li>
			    <li id="tag3_2"><a href="#" onclick="getTab3(2)">事件分析</a></li>
			    <li id="tag3_3"><a href="#" onclick="getTab3(3)">经济损失</a></li>
			  </ul>
			</div>
			
			<div id="tab_box" class="tab_box">
			<form name="form" id="form"  method="post" action="">
			<input type="hidden" id="hse_event_id" name="hse_event_id"></input>
			<input type="hidden" id="isProject" name="isProject" value="<%=isProject%>"></input>
				<div id="tab_box_content0" class="tab_box_content">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
		                <tr align="right" height="30">
		                  <td>&nbsp;</td>
		                  <td width="30"><span class="bc"><a href="#" onclick="toUpdate()" title="保存"></a></span></td>
		                  <td width="5"></td>
		                </tr>
	             	 </table>
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
					    <td class="inquire_item6"><font color="red">*</font>事件名称：</td>
					    <td class="inquire_form6"><input type="text" id="event_name" name="event_name" class="input_width" /></td>
					    <td class="inquire_item6"><font color="red">*</font>事件类型：</td>
					    <td class="inquire_form6">
					    	<select id="event_type" name="event_type" class="select_width">
					          <option value="" >请选择</option>
					          <option value="1" >工业生产安全事件</option>
					          <option value="2" >火灾事件</option>
					          <option value="3" >道路交通事件</option>
					          <option value="4" >其他事件</option>
						    </select>
						</td>
					    <td class="inquire_item6"><font color="red">*</font>事件日期：</td>
					    <td class="inquire_form6"><input type="text" id="event_date" name="event_date" class="input_width" readonly="readonly"/>
					    &nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton1" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(event_date,tributton1);" />&nbsp;</td>
					  </tr>	
					  <tr>
					   <td class="inquire_item6"><font color="red">*</font>事件性质：</td>
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
					    <td class="inquire_item6"><font color="red">*</font>事件地点：</td>
					    <td class="inquire_form6"><input type="text" id="event_place" name="event_place" class="input_width" /></td>
					    <td class="inquire_item6"><font color="red">*</font>填报日期：</td>
					    <td class="inquire_form6"><input type="text" id="write_date" name="write_date" class="input_width" readonly="readonly"/>
					    &nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton2" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(write_date,tributton2);" />&nbsp;</td>
					  </tr>
					  <tr>
					  <td class="inquire_item6"><font color="red">*</font>是否为承包商：</td>
					    <td class="inquire_form6">
						<select id="out_flag" name="out_flag" class="select_width" onclick="outMust()">
					       <option value="" >请选择</option>
					       <option value="1" >是</option>
					       <option value="0" >否</option>
						</select>
						</td>
					    <td class="inquire_item6"><font color="red" id="out_must" style="display: none;">*</font>承包商名称：</td>
					    <td class="inquire_form6"><input type="text" id="out_name" name="out_name" class="input_width" value=""/></td>
					   <td class="inquire_item6">报告人：</td>
					    <td class="inquire_form6"><input type="text" id="report_name" name="report_name" class="input_width" value=""/></td>
					  </tr>
					  <tr>
					    <td class="inquire_item6">报告时间：</td>
					    <td class="inquire_form6"><input type="text" id="report_date" name="report_date" class="input_width" value="" readonly="readonly"/>
					    &nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton3" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(report_date,tributton3);" />&nbsp;</td>
					    <td class="inquire_item6"></td>
					    <td class="inquire_form6"></td>
					  </tr>
					</table>
				</div>
				<div id="tab_box_content1" class="tab_box_content" style="display:none;">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
		                <tr align="right" height="30">
		                  <td>&nbsp;</td>
		                  <td width="30" id="buttonDis1" ><span class="bc"  onclick="toUpdate()" title="保存"><a href="#"></a></span></td>
		                  <td width="5"></td>
		                </tr>
		              </table>
					<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
					  <tr>
					    <td class="inquire_item6"><font color="red">*</font>本企业伤害人数：</td>
					    <td class="inquire_form6"><input type="text" id="number_owner" name="number_owner" class="input_width" /></td>
					    <td class="inquire_item6"><font color="red">*</font>外部承包商伤害人数：</td>
					    <td class="inquire_form6"><input type="text" id="number_out" name="number_out" class="input_width" /></td>
					    <td class="inquire_item6"><font color="red">*</font>股份承包商伤害人数：</td>
					    <td class="inquire_form6"><input type="text" id="number_stock" name="number_stock" class="input_width" /></td>
					  </tr>
					  <tr>
					    <td class="inquire_item6"><font color="red">*</font>集团承包商伤害人数：</td>
					    <td class="inquire_form6"><input type="text" id="number_group" name="number_group" class="input_width" /></td>
					    <td class="inquire_item6"><font color="red">*</font>限工工时：</td>
					    <td class="inquire_form6"><input type="text" id="number_hours" name="number_hours" class="input_width" /></td>
					    <td class="inquire_item6"></td>
					    <td class="inquire_form6"></td>
					  </tr>	
					</table>
				</div>
				<div id="tab_box_content2" class="tab_box_content" style="display:none;">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
		                <tr align="right" height="30">
		                  <td>&nbsp;</td>
		                  <td width="30" id="buttonDis3" ><span class="bc"  onclick="toUpdate()" title="保存"><a href="#"></a></span></td>
		                  <td width="5"></td>
		                </tr>
		              </table>
					<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
					  <tr>
					    <td class="inquire_item6">事件原因分析人：</td>
					    <td class="inquire_form6"><input type="text" id="analyze_name" name="analyze_name" class="input_width" /></td>
					    <td class="inquire_item6">分析人所在单位：</td>
					    <td class="inquire_form6"><input type="text" id="analyze_work" name="analyze_work" class="input_width" /></td>
					    <td class="inquire_item6"><font color="red">*</font>纠正预防措施完成时间：</td>
					    <td class="inquire_form6"><input type="text" id="result_date" name="result_date" class="input_width" readonly="readonly"/>
					    &nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton4" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(result_date,tributton4);" />&nbsp;</td></td>
					  </tr>	
					  <tr>
					    <td class="inquire_item6"><font color="red">*</font>责任人：</td>
					    <td class="inquire_form6"><input type="text" id="duty_name" name="duty_name" class="input_width" /></td>
					    <td class="inquire_item6"></td>
					    <td class="inquire_item6"></td>
					    <td class="inquire_item6"></td>
					    <td class="inquire_item6"></td>
					  </tr>	
					  <tr>
					    <td class="inquire_item6"><font color="red">*</font>事件经过描述：</td>
					    <td class="inquire_form6" colspan="5"><textarea id="event_process" name="event_process" class="textarea" ></textarea></td>
					  </tr>	
					  <tr>
					    <td class="inquire_item6"><font color="red">*</font>事件原因：</td>
					    <td class="inquire_form6" colspan="5"><textarea id="event_reason" name="event_reason"   class="textarea" ></textarea></td>
					  </tr>	
					 
					  <tr style="display:none">
					    <td class="inquire_item6"><font color="red">*</font>事件原因描述：</td>
					    <td class="inquire_form6" colspan="5"><textarea id="event_describe" name="event_describe"  class="textarea"  ></textarea></td>
					  </tr>	
					 
					  <tr>
					    <td class="inquire_item6"><font color="red">*</font>采取纠正预防措施：</td>
					    <td class="inquire_form6" colspan="5"><textarea id="event_result" name="event_result"  class="textarea"  ></textarea></td>
					  </tr>	 
					</table>
				</div>
				<div id="tab_box_content3" class="tab_box_content" style="display:none;">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
		                <tr align="right" height="30">
		                  <td>&nbsp;</td>
		                  <td width="30" id="buttonDis1" ><span class="bc"  onclick="toUpdate()" title="保存"><a href="#"></a></span></td>
		                  <td width="5"></td>
		                </tr>
		              </table>
					<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
					  <tr>
					    <td class="inquire_item6"><font color="red">*</font>直接经济损失：</td>
					    <td class="inquire_form6"><input type="text" id="first_money" name="first_money" class="input_width"  onchange="addMoney()"/>元</td>
					    <td class="inquire_item6"><font color="red">*</font>间接经济损失：</td>
					    <td class="inquire_form6"><input type="text" id="second_money" name="second_money" class="input_width"  onchange="addMoney()"/>元</td>
					    <td class="inquire_item6"><font color="red">*</font>经济损失合计：</td>
					    <td class="inquire_form6"><input type="text" id="all_money" name="all_money" class="input_width" readonly="readonly"/>元</td>
					  </tr>
					</table>
				</div>
				</form>
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
	
	//键盘上只有删除键，和左右键好用
	function noEdit(event){
		if(event.keyCode==8|| event.keyCode ==37 || event.keyCode ==39){
			return true;
		}else{
			return false;
		}
	}
	
	// 复杂查询
	function refreshData(){
		cruConfig.cdtType = 'form';
		var isProject = "<%=isProject%>";
		var sql = "";
		if(isProject=="1"){
			sql = getMultipleSql();
		}else if(isProject=="2"){
			sql = "and t.project_info_no='<%=user.getProjectInfoNo()%>'";
		}
		cruConfig.queryStr = "select t.hse_event_id,t.second_org,t.third_org,t.event_name,t.event_date,t.event_place,decode(t.event_type,'1','工业生产安全事件','2','火灾事件','3','道路交通事件','4','其他事件') as event_type,decode(t.event_property,'1','限工事件','2','医疗事件','3','急救箱事件','4','经济损失事件','5','未遂事件') as event_property,oi1.org_abbreviation as second_org_name,oi2.org_abbreviation as third_org_name,oi3.org_abbreviation as fourth_org_name,t.create_date,t.modifi_date from bgp_hse_event t left join comm_org_subjection os1 on t.second_org = os1.org_subjection_id and os1.bsflag = '0' left join comm_org_information oi1 on oi1.org_id = os1.org_id and oi1.bsflag = '0' left join comm_org_subjection os2 on t.third_org = os2.org_subjection_id and os2.bsflag = '0' left join comm_org_information oi2 on oi2.org_id = os2.org_id and oi2.bsflag = '0'  left join comm_org_subjection os3 on t.fourth_org = os3.org_subjection_id and os3.bsflag = '0' left join comm_org_information oi3 on oi3.org_id = os3.org_id and oi3.bsflag = '0'  where t.bsflag = '0' "+sql+" order by modifi_date desc";
		cruConfig.currentPageUrl = "/hse/event/event_list.jsp";
		queryData(1);
	}
	
	function refreshData2(sql){
		cruConfig.cdtType = 'form';
		cruConfig.queryStr = sql;
		cruConfig.currentPageUrl = "/hse/event/event_list.jsp";
		queryData(1);
	}
	
	function chooseOne(cb){   
	    var obj = document.getElementsByName("rdo_entity_id");   
	    for (i=0; i<obj.length; i++){   
	       	if (obj[i]!=cb) obj[i].checked = false;   
	        else obj[i].checked = true;   
	    }   
	}   
	
	// 简单查询
	function simpleSearch(){
			var eventName = document.getElementById("eventName").value;
				if(eventName!=''&&eventName!=null){
					var isProject = "<%=isProject%>";
					var sql = "";
					if(isProject=="1"){
						sql = getMultipleSql();
					}else if(isProject=="2"){
						sql = "and t.project_info_no='<%=user.getProjectInfoNo()%>'";
					}
					cruConfig.cdtType = 'form';
					cruConfig.queryStr = "select t.hse_event_id,t.second_org,t.third_org,t.event_name,t.event_date,t.event_place,decode(t.event_type,'1','工业生产安全事件','2','火灾事件','3','道路交通事件','4','其他事件') as event_type,decode(t.event_property,'1','限工事件','2','医疗事件','3','急救箱事件','4','经济损失事件','5','未遂事件') as event_property,oi1.org_abbreviation as second_org_name,oi2.org_abbreviation as third_org_name,oi3.org_abbreviation as fourth_org_name,t.create_date,t.modifi_date from bgp_hse_event t left join comm_org_subjection os1 on t.second_org = os1.org_subjection_id and os1.bsflag = '0' left join comm_org_information oi1 on oi1.org_id = os1.org_id and oi1.bsflag = '0' left join comm_org_subjection os2 on t.third_org = os2.org_subjection_id and os2.bsflag = '0' left join comm_org_information oi2 on oi2.org_id = os2.org_id and oi2.bsflag = '0'  left join comm_org_subjection os3 on t.fourth_org = os3.org_subjection_id and os3.bsflag = '0' left join comm_org_information oi3 on oi3.org_id = os3.org_id and oi3.bsflag = '0'  where t.bsflag = '0' "+sql+" and t.event_name like '%"+eventName+"%' order by t.modifi_date desc";
					cruConfig.currentPageUrl = "/hse/event/event_list.jsp";
					queryData(1);
				}else{
					refreshData();
				}
	}
	
	function clearQueryText(){
		document.getElementById("eventName").value = "";
	}
	
	function loadDataDetail(shuaId){
		var retObj;
		if(shuaId!=null){
			 retObj = jcdpCallService("HseSrv", "viewEvent", "hse_event_id="+shuaId);
			
		}else{
			var ids = getSelIds('rdo_entity_id');
		    if(ids==''){ 
			    alert("请先选中一条记录!");
	     		return;
		    }
		    retObj = jcdpCallService("HseSrv", "viewEvent", "hse_event_id="+ids);
		}
		document.getElementById("hse_event_id").value =retObj.map.hseEventId;
		document.getElementById("second_org").value =retObj.map.secondOrg;
		document.getElementById("third_org").value =retObj.map.thirdOrg;
		document.getElementById("fourth_org").value =retObj.map.fourthOrg;
		document.getElementById("second_org2").value =retObj.map.secondOrgName;
		document.getElementById("third_org2").value =retObj.map.thirdOrgName;
		document.getElementById("fourth_org2").value =retObj.map.fourthOrgName;
		document.getElementById("event_name").value =retObj.map.eventName;
		document.getElementById("event_type").value = retObj.map.eventType;
		document.getElementById("event_property").value = retObj.map.eventProperty;
		document.getElementById("event_date").value = retObj.map.eventDate;
		document.getElementById("event_place").value = retObj.map.eventPlace;
		document.getElementById("write_date").value = retObj.map.writeDate;
		document.getElementById("out_flag").value = retObj.map.outFlag;
		document.getElementById("out_name").value = retObj.map.outName;
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

	var selectedTagIndex = 0;//document.getElementById("tag3_0").parentElement;
	var showTabBox = document.getElementById("tab_box_content0");
	
	
	function toAdd(){
		popWindow("<%=contextPath%>/hse/event/addEvent.jsp?isProject=<%=isProject%>");
		
	}
	
	function toEdit(){  
		var hse_event_id = document.getElementById("hse_event_id").value;
	  	if(hse_event_id==''||hse_event_id==null){  
	  		alert("请选择一条信息!");  
	  		return;  
	  	}  
	  	popWindow("<%=contextPath%>/hse/viewEvent.srq?isProject=<%=isProject%>&hse_event_id="+hse_event_id);
	  	
	} 
	
	function outMust(){
		if(document.getElementById("out_flag").value=="1"){
			document.getElementById("out_must").style.display="";
			document.getElementById("out_name").disabled="";
		}else{
			document.getElementById("out_must").style.display="none";
			document.getElementById("out_name").disabled="disabled";
		}
	}
	
	function addMoney(){
		var first_money = document.getElementById("first_money").value;
		var second_money = document.getElementById("second_money").value;
		first_money = Number(first_money);
		second_money = Number(second_money);
		document.getElementById("all_money").value=first_money+second_money;
	}
	
	function toUpdate(){  
		var form = document.getElementById("form");
		form.action="<%=contextPath%>/hse/accident/updateEvent.srq";
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
		form.submit();
	} 
	
	
	function checkText0(){
		var second_org=document.getElementById("second_org").value;
		var third_org=document.getElementById("third_org").value;
		var event_name=document.getElementById("event_name").value;
		var event_type=document.getElementById("event_type").value;
		var event_property=document.getElementById("event_property").value;
		var event_date=document.getElementById("event_date").value;
		var event_place=document.getElementById("event_place").value;
		var write_date=document.getElementById("write_date").value;
		var out_flag = document.getElementById("out_flag").value;
		var out_name = document.getElementById("out_name").value;
		if(second_org==""){
			alert("二级单位不能为空，请填写！");
			return true;
		}
		if(third_org==""){
			alert("基层单位不能为空，请填写！");
			return true;
		}
		if(event_name==""){
			alert("事件名称不能为空，请填写！");
			return true;
		}
		if(event_type==""){
			alert("事件类型不能为空，请选择！");
			return true;
		}
		if(event_property==""){
			alert("事件性质不能为空，请选择！");
			return true;
		}
		if(event_date==""){
			alert("事件日期不能为空，请填写！");
			return true;
		}
		if(event_place==""){
			alert("事件地点不能为空，请填写！");
			return true;
		}
		if(write_date==""){
			alert("填报日期不能为空，请填写！");
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
		}
		return false;
	}

	function checkText1(){
		debugger;
		var number_owner = document.getElementById("number_owner").value;
		var number_out=document.getElementById("number_out").value;
		var number_stock=document.getElementById("number_stock").value;
		var number_group=document.getElementById("number_group").value;
		var number_hours=document.getElementById("number_hours").value;
		var re = /^[0-9]+\.?[0-9]*$/;   //判断字符串是否为数字     //判断正整数 /^[1-9]+[0-9]*]*$/  

	    
		if(number_owner==""){
			alert("本企业伤害人数不能为空，请填写！");
			return true;
		}
		if (!re.test(number_owner))
		   {
		       alert("本企业伤害人数请输入数字！");
		       return true;
		    }
		if(number_out==""){
			alert("外部承包商伤害人数不能为空，请填写！");
			return true;
		}
		if (!re.test(number_out))
		   {
		       alert("外部承包商伤害人数请输入数字！");
		       return true;
		    }
		if(number_stock==""){
			alert("股份承包商伤害人数不能为空，请填写！");
			return true;
		}
		if (!re.test(number_stock))
		   {
		       alert("股份承包商伤害人数请输入数字！");
		       return true;
		    }
		if(number_group==""){
			alert("集团承包商伤害人数不能为空，请填写！");
			return true;
		}
		if (!re.test(number_group))
		   {
		       alert("集团承包商伤害人数请输入数字！");
		       return true;
		    }
		if(number_hours==""){
			alert("限工工时不能为空，请填写！");
			return true;
		}
		if (!re.test(number_hours))
		   {
		       alert("限工工时请输入数字！");
		       return true;
		    }
		return false;
	}

	function checkText2(){
		var result_date=document.getElementById("result_date").value;
		var duty_name=document.getElementById("duty_name").value;
		var event_process=document.getElementById("event_process").value;
		var event_reason = document.getElementById("event_reason").value;
		var event_describe=document.getElementById("event_describe").value;
		var event_result=document.getElementById("event_result").value;
		if(result_date==""){
			alert("纠正预防措施完成时间不能为空，请填写！");
			return true;
		}
		if(duty_name==""){
			alert("责任人不能为空，请填写！");
			return true;
		}
		if(event_process==""){
			alert("事件经过描述不能为空，请填写！");
			return true;
		}
		if(event_reason==""){
			alert("事件原因不能为空，请填写！");
			return true;
		}
		if(event_result==""){
			alert("采取的纠正预防措施不能为空，请填写！");
			return true;
		}
		return false;
	}

	function checkText3(){
		var first_money = document.getElementById("first_money").value;
		var second_money = document.getElementById("second_money").value;
		var all_money = document.getElementById("all_money").value;
		var re = /^[0-9]+\.?[0-9]*$/;   //判断字符串是否为数字     //判断正整数 /^[1-9]+[0-9]*]*$/  

	    
		if(first_money==""){
			alert("直接经济损失不能为空，请填写！");
			return true;
		}
		if (!re.test(first_money))
		   {
		       alert("直接经济损失请输入数字！");
		       return true;
		    }
		if(second_money==""){
			alert("间接经济损失不能为空，请填写！");
			return true;
		}
		if (!re.test(second_money))
		   {
		       alert("间接经济损失请输入数字！");
		       return true;
		    }
		if(all_money==""){
			alert("经济损失合计不能为空，请填写！");
			return true;
		}
		if (!re.test(all_money))
		   {
		       alert("经济损失合计请输入数字！");
		       return true;
		    }
		return false;
	}
	

	function toDelete(){
 		
	    ids = getSelIds('rdo_entity_id');
	    if(ids==''){ alert("请先选中一条记录!");
	     	return;
	    }	
		    
		if(confirm('确定要删除吗?')){  
			var retObj = jcdpCallService("HseSrv", "deleteEvent", "hse_event_id="+ids);
			queryData(cruConfig.currentPage);
		}
	}

	function toSearch(){
		popWindow("<%=contextPath%>/hse/event/event_search.jsp?isProject=<%=isProject%>");
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
	
</script>

</html>


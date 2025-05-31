<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.webapp.util.JcdpMVCUtil" %>
<%@page import="com.cnpc.jcdp.cfg.BeanFactory"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@ page import="java.util.*"%>
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
			    <td class="ali_cdn_input"><input id="accidentName" name="accidentName" type="text" /></td>
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
			      <td class="bt_info_odd" exp="<input type='checkbox' name='rdo_entity_id' value='{hse_accident_id}' id='rdo_entity_id_{hse_accident_id}' onclick='loadDataDetail();'/>" >选择</td>
			      <td class="bt_info_even" autoOrder="1">序号</td> 
			      <td class="bt_info_odd" exp="{second_org_name}">单位</td>
			      <td class="bt_info_even" exp="{third_org_name}">基层单位</td>
			      <td class="bt_info_odd" exp="{fourth_org_name}">下属单位</td>
			      <td class="bt_info_even" exp="{accident_name}">事故名称</td>
			      <td class="bt_info_odd" exp="{coding_name}">事故类型</td>
			      <td class="bt_info_even" exp="{accident_date}">事故日期</td>
			      <td class="bt_info_odd" exp="{accident_place}">事故地点</td>
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
			    <li id="tag3_1"><a href="#" onclick="getTab3(1)">伤亡情况</a></li>
			    <li id="tag3_2"><a href="#" onclick="getTab3(2)">事故简要描述</a></li>
			  </ul>
			</div>
			
			<div id="tab_box" class="tab_box">
			<form name="form" id="form"  method="post" action="">
			<input type="hidden" id="hse_accident_id" name="hse_accident_id"></input>
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
					    <td class="inquire_item6"><font color="red">*</font>事故名称：</td>
					    <td class="inquire_form6"><input type="text" id="accident_name" name="accident_name" class="input_width" /></td>
					    <td class="inquire_item6"><font color="red">*</font>事故类型：</td>
					    <td class="inquire_form6">
					    	<select id="accident_type" name="accident_type" class="select_width">
					          <option value="" >请选择</option>
					          <%
					          	String sql = "select * from comm_coding_sort_detail where coding_sort_id='5110000042' and superior_code_id='0' and bsflag='0' order by coding_show_id desc";
					          	List list = BeanFactory.getQueryJdbcDAO().queryRecords(sql);
					          	for(int i=0;i<list.size();i++){
					          		Map map = (Map)list.get(i);
					          		String coding_id = (String)map.get("codingCodeId");
					          		String coding_name = (String)map.get("codingName");
					       %>
					       <option value="<%=coding_id %>" ><%=coding_name %></option>
					       <%} %>
						    </select>
						</td>
					    <td class="inquire_item6"><font color="red">*</font>事故日期：</td>
					    <td class="inquire_form6"><input type="text" id="accident_date" name="accident_date" class="input_width" readonly="readonly"/>
					    &nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton1" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(accident_date,tributton1);" />&nbsp;</td>
					  </tr>	
					  <tr>
					   	<td class="inquire_item6"><font color="red">*</font>事故地点：</td>
					    <td class="inquire_form6"><input type="text" id="accident_place" name="accident_place" class="input_width"/></td>
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
						<select id="out_flag" name="out_flag" class="select_width"  onclick="outMust()">
					       <option value="" >请选择</option>
					       <option value="1" >是</option>
					       <option value="0" >否</option>
						</select>
						</td>
					  </tr>
					  <tr>
					    <td class="inquire_item6"><font color="red" id="out_must1" style="display: none">*</font>承包商名称：</td>
					    <td class="inquire_form6"><input type="text" id="out_name" name="out_name" class="input_width" /></td>
					    <td class="inquire_item6"><font color="red" id="out_must2" style="display: none">*</font>承包商类型：</td>
					    <td class="inquire_form6">
					    <select id="out_type" name="out_type" class="select_width">
					       <option value="" >请选择</option>
					       <option value="1" >集团内</option>
					       <option value="0" >集团外</option>
						</select>
					    </td>
					    <td class="inquire_item6"><font color="red">*</font>初步估计经济损失：</td>
					    <td class="inquire_form6"><input type="text" id="accident_money" name="accident_money" class="input_width" />元</td>
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
					    <td class="inquire_item6"><font color="red">*</font>死亡人数：</td>
					    <td class="inquire_form6"><input type="text" id="number_die" name="number_die" class="input_width" /></td>
					    <td class="inquire_item6"><font color="red">*</font>重伤人数：</td>
					    <td class="inquire_form6"><input type="text" id="number_harm" name="number_harm" class="input_width" /></td>
					    <td class="inquire_item6"><font color="red">*</font>轻伤人数：</td>
					    <td class="inquire_form6"><input type="text" id="number_injure" name="number_injure" class="input_width" /></td>
					  </tr>
					  <tr>
					    <td class="inquire_item6"><font color="red">*</font>失踪人数：</td>
					    <td class="inquire_form6"><input type="text" id="number_lose" name="number_lose" class="input_width" /></td>
					    <td class="inquire_item6"></td>
					    <td class="inquire_item6"></td>
					    <td class="inquire_item6"></td>
					    <td class="inquire_item6"></td>
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
					    <td class="inquire_item6"><font color="red">*</font>填报日期：</td>
					    <td class="inquire_form6"><input type="text" id="write_date" name="write_date" class="input_width" readonly="readonly"/>
					    &nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton2" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(write_date,tributton2);" />&nbsp;</td></td>
					    <td class="inquire_item6"><font color="red">*</font>填报人：</td>
					    <td class="inquire_form6"><input type="text" id="write_name" name="write_name" class="input_width" /></td>
					    <td class="inquire_item6"><font color="red">*</font>责任人：</td>
					    <td class="inquire_form6"><input type="text" id="duty_name" name="duty_name" class="input_width" /></td>
					  </tr>	
					  <tr>
					    <td class="inquire_item6"><font color="red">*</font>事故简要经过：<br>(字数不得小于50字)</td>
					    <td class="inquire_form6" colspan="5"><textarea id="accident_process" name="accident_process"   class="textarea" ></textarea></td>
					  </tr>	
					  <tr>
					    <td class="inquire_item6"><font color="red">*</font>初步原因分析：<br>(字数不得小于30字)</td>
					    <td class="inquire_form6" colspan="5"><textarea id="accident_reason" name="accident_reason"   class="textarea" ></textarea></td>
					  </tr>	
					  <tr>
					    <td class="inquire_item6"><font color="red">*</font>目前处理情况：</td>
					    <td class="inquire_form6" colspan="5"><textarea id="accident_result" name="accident_result"  class="textarea"></textarea></td>
					  </tr>	
					  <tr>
					    <td class="inquire_item6"><font color="red">*</font>意见：</td>
					    <td class="inquire_form6" colspan="5"><textarea id="accident_sugg" name="accident_sugg"   class="textarea" ></textarea></td>
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
		cruConfig.queryStr = "select t.hse_accident_id,t.second_org,t.third_org,t.accident_name,t.accident_date,t.accident_place,t.accident_type,sd.coding_name,oi1.org_abbreviation as second_org_name,oi2.org_abbreviation as third_org_name,oi3.org_abbreviation as fourth_org_name,t.create_date,t.modifi_date from bgp_hse_accident_news t left join comm_org_subjection os1 on t.second_org = os1.org_subjection_id and os1.bsflag = '0' left join comm_org_information oi1 on oi1.org_id = os1.org_id and oi1.bsflag = '0' left join comm_org_subjection os2 on t.third_org = os2.org_subjection_id and os2.bsflag = '0' left join comm_org_information oi2 on oi2.org_id = os2.org_id and oi2.bsflag = '0'  left join comm_org_subjection os3 on t.fourth_org = os3.org_subjection_id and os3.bsflag = '0' left join comm_org_information oi3 on oi3.org_id = os3.org_id and oi3.bsflag = '0' left join comm_coding_sort_detail sd on sd.coding_code_id=t.accident_type and sd.bsflag='0' where t.bsflag = '0' "+sql+" order by modifi_date desc";
		cruConfig.currentPageUrl = "/hse/accidentNews/accident_list.jsp";
		queryData(1);
	}
	
	function refreshData2(sql){
		cruConfig.cdtType = 'form';
		cruConfig.queryStr = sql;
		cruConfig.currentPageUrl = "/hse/accidentNews/accident_list.jsp";
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
			var accidentName = document.getElementById("accidentName").value;
			var isProject = "<%=isProject%>";
			var sql = "";
			if(isProject=="1"){
				sql = getMultipleSql();
			}else if(isProject=="2"){
				sql = "and t.project_info_no='<%=user.getProjectInfoNo()%>'";
			}
				if(accidentName!=''&&accidentName!=null){
					cruConfig.cdtType = 'form';
					cruConfig.queryStr = "select t.hse_accident_id,t.second_org,t.third_org,t.accident_name,t.accident_date,t.accident_place,t.accident_type,sd.coding_name,oi1.org_abbreviation as second_org_name,oi2.org_abbreviation as third_org_name,oi3.org_abbreviation as fourth_org_name,t.create_date,t.modifi_date from bgp_hse_accident_news t left join comm_org_subjection os1 on t.second_org = os1.org_subjection_id and os1.bsflag = '0' left join comm_org_information oi1 on oi1.org_id = os1.org_id and oi1.bsflag = '0' left join comm_org_subjection os2 on t.third_org = os2.org_subjection_id and os2.bsflag = '0' left join comm_org_information oi2 on oi2.org_id = os2.org_id and oi2.bsflag = '0'  left join comm_org_subjection os3 on t.fourth_org = os3.org_subjection_id and os3.bsflag = '0' left join comm_org_information oi3 on oi3.org_id = os3.org_id and oi3.bsflag = '0' left join comm_coding_sort_detail sd on sd.coding_code_id=t.accident_type and sd.bsflag='0' where t.bsflag = '0' "+sql+" and t.accident_name like '%"+accidentName+"%' order by t.modifi_date desc";
					cruConfig.currentPageUrl = "/hse/accidentNews/accident_list.jsp";
					queryData(1);
				}else{
					refreshData();
				}
	}
	
	function clearQueryText(){
		document.getElementById("accidentName").value = "";
	}
	
	function loadDataDetail(shuaId){
		var retObj;
		if(shuaId!=null){
			 retObj = jcdpCallService("HseSrv", "viewAccident", "hse_accident_id="+shuaId);
			
		}else{
			var ids = getSelIds('rdo_entity_id');
		    if(ids==''){ 
			    alert("请先选中一条记录!");
	     		return;
		    }
		    retObj = jcdpCallService("HseSrv", "viewAccident", "hse_accident_id="+ids);
		}
		document.getElementById("hse_accident_id").value =retObj.map.hseAccidentId;
		document.getElementById("second_org").value =retObj.map.secondOrg;
		document.getElementById("third_org").value =retObj.map.thirdOrg;
		document.getElementById("fourth_org").value =retObj.map.fourthOrg;
		document.getElementById("second_org2").value =retObj.map.secondOrgName;
		document.getElementById("third_org2").value =retObj.map.thirdOrgName;
		document.getElementById("fourth_org2").value =retObj.map.fourthOrgName;
		document.getElementById("accident_name").value =retObj.map.accidentName;
		document.getElementById("accident_type").value = retObj.map.accidentType;
		document.getElementById("accident_date").value = retObj.map.accidentDate;
		document.getElementById("accident_place").value = retObj.map.accidentPlace;
		document.getElementById("workplace_flag").value = retObj.map.workplaceFlag;
		document.getElementById("out_flag").value = retObj.map.outFlag;
		document.getElementById("out_type").value = retObj.map.outType;
		document.getElementById("out_name").value = retObj.map.outName;
		document.getElementById("accident_money").value = retObj.map.accidentMoney;
		document.getElementById("number_die").value = retObj.map.numberDie;
		document.getElementById("number_harm").value = retObj.map.numberHarm;
		document.getElementById("number_injure").value = retObj.map.numberInjure;
		document.getElementById("number_lose").value = retObj.map.numberLose;
		document.getElementById("accident_process").value = retObj.map.accidentProcess;
		document.getElementById("accident_reason").value = retObj.map.accidentReason;
		document.getElementById("accident_result").value = retObj.map.accidentResult;
		document.getElementById("accident_sugg").value = retObj.map.accidentSugg;
		document.getElementById("write_date").value = retObj.map.writeDate;
		document.getElementById("write_name").value = retObj.map.writeName;
		document.getElementById("duty_name").value = retObj.map.dutyName;
		
	}

	var selectedTagIndex = 0;//document.getElementById("tag3_0").parentElement;
	var showTabBox = document.getElementById("tab_box_content0");
	
	
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
	
	function toAdd(){
		popWindow("<%=contextPath%>/hse/accidentNews/addAccident.jsp?isProject=<%=isProject%>","1000:675");
		
	}
	
	function toEdit(){  
		debugger;
		var hse_accident_id = document.getElementById("hse_accident_id").value;
	  	if(hse_accident_id==''||hse_accident_id==null){  
	  		alert("请选择一条信息!");  
	  		return;  
	  	}  
	  	popWindow("<%=contextPath%>/hse/viewAccident.srq?isProject=<%=isProject%>&hse_accident_id="+hse_accident_id,"1000:675");
	  	
	} 
	
	function toUpdate(){  
		var form = document.getElementById("form");
		form.action="<%=contextPath%>/hse/accident/updateNewsInfo.srq";
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
		form.submit();
	} 
	
	
	function checkText0(){
		var second_org2=document.getElementById("second_org2").value;
		var third_org2=document.getElementById("third_org2").value;
		var fourth_org2=document.getElementById("fourth_org2").value;
		var accident_name=document.getElementById("accident_name").value;
		var accident_type=document.getElementById("accident_type").value;
		var accident_date=document.getElementById("accident_date").value;
		var accident_place=document.getElementById("accident_place").value;
		var workplace_flag = document.getElementById("workplace_flag").value;
		var accident_money = document.getElementById("accident_money").value;
		var out_flag = document.getElementById("out_flag").value;
		var out_name = document.getElementById("out_name").value;
		var out_type = document.getElementById("out_type").value;
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
		if(accident_date==""){
			alert("事故日期不能为空，请填写！");
			return true;
		}
		if(accident_place==""){
			alert("事故地点不能为空，请填写！");
			return true;
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
		if(accident_money==""){
			alert("初步估计经济损失不能为空，请填写！");
			return true;
		}
		var re = /^[0-9]+\.?[0-9]*$/;   //判断字符串是否为数字     //判断正整数 /^[1-9]+[0-9]*]*$/  

	    if (!re.test(accident_money))
	   {
	       alert("初步估计经济损失请输入数字！");
	       return true;
	    }
		return false;
	}

	function checkText1(){
		var number_die = document.getElementById("number_die").value;
		var number_harm=document.getElementById("number_harm").value;
		var number_injure=document.getElementById("number_injure").value;
		var number_lose=document.getElementById("number_lose").value;
		var re = /^[0-9]+\.?[0-9]*$/;   //判断字符串是否为数字     //判断正整数 /^[1-9]+[0-9]*]*$/  

	    
		if(number_die==""){
			alert("死亡人数不能为空，请填写！");
			return true;
		}
		if (!re.test(number_die))
		   {
		       alert("死亡人数请输入数字！");
		       return true;
		    }
		if(number_harm==""){
			alert("重伤人数不能为空，请填写！");
			return true;
		}
		if (!re.test(number_harm))
		   {
		       alert("重伤人数请输入数字！");
		       return true;
		    }
		if(number_injure==""){
			alert("轻伤人数不能为空，请填写！");
			return true;
		}
		if (!re.test(number_injure))
		   {
		       alert("轻伤人数请输入数字！");
		       return true;
		    }
		if(number_lose==""){
			alert("失踪人数不能为空，请填写！");
			return true;
		}
		if (!re.test(number_lose))
		   {
		       alert("失踪人数请输入数字！");
		       return true;
		    }
		return false;
	}

	function checkText2(){
		debugger;
		var write_date=document.getElementById("write_date").value;
		var write_name=document.getElementById("write_name").value;
		var duty_name = document.getElementById("duty_name").value;
		var accident_process=document.getElementById("accident_process").value;
		var accident_reason=document.getElementById("accident_reason").value;
		var accident_result=document.getElementById("accident_result").value;
		var accident_sugg=document.getElementById("accident_sugg").value;
		if(write_date==""){
			alert("填报日期不能为空，请填写！");
			return true;
		}
		if(write_name==""){
			alert("填报人不能为空，请填写！");
			return true;
		}
		if(duty_name==""){
			alert("负责人不能为空，请填写！");
			return true;
		}
		if(accident_process==""){
			alert("事故简要经过不能为空，请填写！");
			return true;
		}
		if(accident_process.length<50){
			alert("事故简要经过不得小于50字！");
			return true;
		}
		if(accident_reason==""){
			alert("初步原因分析不能为空，请填写！");
			return true;
		}
		if(accident_reason.length<30){
			alert("初步原因分析不得小于30字！");
			return true;
		}
		if(accident_result==""){
			alert("目前处理情况不能为空，请填写！");
			return true;
		}
		if(accident_sugg==""){
			alert("意见不能为空，请选择！");
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
			var retObj = jcdpCallService("HseSrv", "deleteAccident", "hse_accident_id="+ids);
			queryData(cruConfig.currentPage);
		}
	}

	function toSearch(){
		popWindow("<%=contextPath%>/hse/accidentNews/accident_search.jsp?isProject=<%=isProject%>");
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


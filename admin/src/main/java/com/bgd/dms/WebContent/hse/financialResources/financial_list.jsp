<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.webapp.util.JcdpMVCUtil" %>
<%@page import="java.util.Date,java.text.SimpleDateFormat"%>
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
	SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
	String today = format.format(new Date());
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
			    <td class="ali_cdn_name">项目名称</td>
			    <td class="ali_cdn_input"><input id="name" name="name" type="text" /></td>
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
			      <td class="bt_info_odd" exp="<input type='checkbox' name='rdo_entity_id' value='{hse_financial_id}' id='rdo_entity_id_{hse_financial_id}' onclick='loadDataDetail();'/>" >选择</td>
			      <td class="bt_info_even" autoOrder="1">序号</td> 
			      <td class="bt_info_odd" exp="{second_org_name}">单位</td>
			      <td class="bt_info_even" exp="{third_org_name}">基层单位</td>
			      <td class="bt_info_odd" exp="{fourth_org_name}">下属单位</td>
			      <td class="bt_info_even" exp="{project_name}">项目名称</td>
			      <td class="bt_info_odd" exp="{plan_money}">计划所需资金(万元)</td>
			      <td class="bt_info_even" exp="{plan_flag}">是否计划内</td>
			      <td class="bt_info_odd" exp="{input_money}">投入资金(万元)</td>
			      <td class="bt_info_even" exp="{declare_date}">申报日期</td>
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
			    <li class="selectTag" id="tag3_0"><a href="#" onclick="getTab3(0)">计划</a></li>
			    <li id="tag3_1"><a href="#" onclick="getTab3(1)">实施</a></li>
			    <li id="tag3_2"><a href="#" onclick="getTab3(2)">验收</a></li>
			  </ul>
			</div>
			
			<div id="tab_box" class="tab_box">
			<input type="hidden" id="hse_financial_id" name="hse_financial_id"></input>
			<input type="hidden" id="hse_detail_id" name="hse_detail_id"></input>
			<input type="hidden" id="isProject" name="isProject" value="<%=isProject%>"></input>
				<div id="tab_box_content0" class="tab_box_content">
				<form name="form0" id="form0"  method="post" action="">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
		                <tr align="right" height="30">
			                  <td>&nbsp;</td>
			                  <td width="30" id="buttonDis1" ><span class="bc"  onclick="toUpdate()" title="保存"><a href="#"></a></span></td>
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
						    <td class="inquire_item6"><font color="red">*</font>项目名称：</td>
						    <td class="inquire_form6"><input type="text" id="project_name" name="project_name" class="input_width" /></td>
						    <td class="inquire_item6"><font color="red">*</font>计划所需资金(万元)：</td>
						    <td class="inquire_form6"><input type="text" id="plan_money" name="plan_money" class="input_width" /></td>
						    <td class="inquire_item6"><font color="red">*</font>申报人：</td>
						    <td class="inquire_form6"><input type="text" id="declare_person" name="declare_person" value="" class="input_width" /></td>
					  	</tr>
					  	<tr>
						    <td class="inquire_item6"><font color="red">*</font>资金来源：</td>
						    <td class="inquire_form6" colspan="3">
						    	<input type="hidden" id="money_source" name="money_source" value=""/>
					      		<input type="checkbox"  name="selected" value="1">集团公司</input>&nbsp;&nbsp;&nbsp;
					      		<input type="checkbox"  name="selected" value="2">公司</input>&nbsp;&nbsp;&nbsp;
					      		<input type="checkbox"  name="selected" value="3">二级单位</input>&nbsp;&nbsp;&nbsp;
					      		<input type="checkbox"  name="selected" value="4">基层单位</input>&nbsp;&nbsp;&nbsp;
					      	</td>
						    <td class="inquire_item6"><font color="red">*</font>申报日期：</td>
						    <td class="inquire_form6"><input type="text" id="declare_date" name="declare_date" class="input_width" value="" readonly="readonly"/>
						   	 &nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton1" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(declare_date,tributton1);" />&nbsp;
						    </td>
					  	</tr>	
					</table>
					</form>
				</div>
				<div id="tab_box_content1" class="tab_box_content" style="display:none;">
				<form name="form1" id="form1"  method="post" action="">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
		                <tr align="right" height="30">
			                  <td>&nbsp;</td>
			                  <td width="30" id="buttonDis2" ><span class="bc"  onclick="toUpdate()" title="保存"><a href="#"></a></span></td>
			                  <td width="5"></td>
		                </tr>
		              </table>
					<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
						<tr>
				    		<td class="inquire_item6"><font color="red">*</font>是否计划内：</td>
				      		<td class="inquire_form6">
					      		<select id="plan_flag" name="plan_flag" class="select_width" onclick="ifPlanFlag()">
						          <option value="" >请选择</option>
						          <option value="0" >是</option>
						          <option value="1" >否</option>
							    </select>
				      		</td>
				      		<td class="inquire_item6">单位：</td>
					      	<td class="inquire_form6">
						      	<input type="hidden" id="second_org22" name="second_org22" class="input_width" />
						      	<input type="text" id="second_org222" name="second_org222" class="input_width" readonly="readonly" />
						      	<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="selectOrg4()"/>
					      	</td>
					     	<td class="inquire_item6">基层单位：</td>
					      	<td class="inquire_form6">
						      	<input type="hidden" id="third_org22" name="third_org22" class="input_width" />
						      	<input type="text" id="third_org222" name="third_org222" class="input_width"  readonly="readonly"/>
					      		<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="selectOrg5()"/>
					      	</td>
					  	</tr>
					  	<tr>
					      	<td class="inquire_item6">下属单位：</td>
					      	<td class="inquire_form6">
						      	<input type="hidden" id="fourth_org22" name="fourth_org22" class="input_width" />
						      	<input type="text" id="fourth_org222" name="fourth_org222" class="input_width"  readonly="readonly"/>
						      	<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="selectOrg6()"/>
					      	</td>
						  	<td class="inquire_item6"><font color="red">*</font>项目名称：</td>
						   	<td class="inquire_form6"><input type="text" id="project_name22" name="project_name22" class="input_width" value=""/></td>
						   	<td class="inquire_item6"><font color="red">*</font>投入资金(万元)：</td>
						   	<td class="inquire_form6"><input type="text" id="input_money" name="input_money" class="input_width" value="" onchange="changeMoney()"/></td>
					  	</tr>
					  	<tr>
						  	<td class="inquire_item6">与计划资金差额(万元)：</td>
						    <td class="inquire_form6">
								<input type="text" id="gap_money" name="gap_money" class="input_width"></input>
							</td>
						  	<td class="inquire_item6"><font color="red">*</font>项目完成时间：</td>
						    <td class="inquire_form6"><input type="text" id="complete_date" name="complete_date" class="input_width" value="" readonly="readonly"/>
						   	 &nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton2" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(complete_date,tributton2);" />&nbsp;
						    </td>
						    <td class="inquire_item6"><font color="red">*</font>负责人：</td>
						    <td class="inquire_form6">
						    	<input type="text" id="duty_person" name="duty_person" class="input_width" value="" />
						    </td>
					  	</tr>
					</table>
					<fieldSet style="margin-left:2px"><legend>资金分配信息</legend>
			 			<div id="table_box" style="height:190px;overflow: auto;">
			  				<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="taskTable">
							<tr  class="bt_info">
								<td>资金来源</td>
								<td>资金分配</td>
							</tr>
							<tr class="odd">
								<td>集团公司</td>
								<td><input type="text" id="money0" name="money0" value="" onchange="totalMoney()"></input></td>	
							</tr>
							<tr class="even">
								<td>公司</td>
								<td><input type="text" id="money1" name="money1" value="" onchange="totalMoney()"></input></td>	
							</tr>
							<tr class="odd">
								<td>二级单位</td>
								<td><input type="text" id="money2" name="money2" value="" onchange="totalMoney()"></input></td>	
							</tr>
							<tr class="even">
								<td>基层单位</td>
								<td><input type="text" id="money3" name="money3" value="" onchange="totalMoney()"></input></td>	
							</tr>
							<tr class="odd">
								<td>合计</td>
								<td><input type="text" id="total_money" name="total_money" ></input></td>	
							</tr>
						 	</table>
						</div>
			      	</fieldSet>
			      	</form>
				</div>
				<div id="tab_box_content2" class="tab_box_content" style="display:none;">
				<form name="form2" id="form2"  method="post" action="">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
		                <tr align="right" height="30">
			                  <td>&nbsp;</td>
			                  <td width="30" id="buttonDis3" ><span class="bc"  onclick="toUpdate()" title="保存"><a href="#"></a></span></td>
			                  <td width="5"></td>
		                </tr>
		              </table>
					<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
						<tr>
				    		<td class="inquire_item6"><font color="red">*</font>验收意见：</td>
				      		<td class="inquire_form6">
					      		<select id="pass_flag" name="pass_flag" class="select_width" onclick="ifPassFlag()">
						          <option value="" >请选择</option>
						          <option value="0" >通过</option>
						          <option value="1" >未通过</option>
							    </select>
				      		</td>
						  	<td class="inquire_item6"><font color="red">*</font>验收人：</td>
						    <td class="inquire_form6">
						    	<input type="text" id="check_person" name="check_person" class="input_width" value="" />
						    </td>
						  	<td class="inquire_item6"><font id="ifPassFlag" color="red" style="display: none;">*</font>验收通过时间：</td>
						    <td class="inquire_form6"><input type="text" id="pass_date" name="pass_date" class="input_width" value="" readonly="readonly"/>
						   	 &nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton3" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(pass_date,tributton3);" />&nbsp;
						    </td>
					  	</tr>
					  	<tr>
						  	<td class="inquire_item6"><font color="red">*</font>验收内容描述：</td>
						    <td class="inquire_form6" colspan="5">
						    	<textarea id="check_describe" name="check_describe" class="textarea"></textarea>
							</td>
					  	</tr>
					</table>
					</form>
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
		var isProject = "<%=isProject%>";
		var querySqlAdd = "";
		if(isProject=="1"){
			querySqlAdd = getMultipleSql("hf.");
		}else if(isProject=="2"){
			querySqlAdd = "and hf.project_info_no='<%=user.getProjectInfoNo()%>'";
		}
		cruConfig.cdtType = 'form';
		cruConfig.queryStr = "select hf.*,decode(fd.plan_flag,'0','是','1','否') plan_flag,fd.input_money,oi1.org_abbreviation second_org_name,oi2.org_abbreviation third_org_name,oi3.org_abbreviation fourth_org_name from bgp_hse_financial hf left join bgp_hse_financial_detail fd on hf.hse_financial_id=fd.hse_financial_id and fd.bsflag='0' left join comm_org_subjection os1 on hf.second_org=os1.org_subjection_id and os1.bsflag='0' left join comm_org_information oi1 on os1.org_id=oi1.org_id and oi1.bsflag='0' left join comm_org_subjection os2 on hf.third_org=os2.org_subjection_id and os2.bsflag='0' left join comm_org_information oi2 on os2.org_id=oi2.org_id and oi2.bsflag='0' left join comm_org_subjection os3 on hf.fourth_org=os3.org_subjection_id and os3.bsflag='0' left join comm_org_information oi3 on os3.org_id=oi3.org_id and oi3.bsflag='0' where hf.bsflag='0' "+querySqlAdd+" order by hf.modifi_date desc ";
		cruConfig.currentPageUrl = "hse/financialResources/financial_list.jsp";
		queryData(1);
	}
	
	function refreshData2(sql){
		cruConfig.cdtType = 'form';
		cruConfig.queryStr = sql;
		cruConfig.currentPageUrl = "hse/financialResources/financial_list.jsp";
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
		var name = document.getElementById("name").value;
		var isProject = "<%=isProject%>";
		var querySqlAdd = "";
		if(isProject=="1"){
			querySqlAdd = getMultipleSql("hf.");
		}else if(isProject=="2"){
			querySqlAdd = "and hf.project_info_no='<%=user.getProjectInfoNo()%>'";
		}
		if(name!=''&&name!=null){
			cruConfig.cdtType = 'form';
			cruConfig.queryStr = "select hf.*,decode(fd.plan_flag,'0','是','1','否') plan_flag,fd.input_money,oi1.org_abbreviation second_org_name,oi2.org_abbreviation third_org_name,oi3.org_abbreviation fourth_org_name from bgp_hse_financial hf left join bgp_hse_financial_detail fd on hf.hse_financial_id=fd.hse_financial_id and fd.bsflag='0' left join comm_org_subjection os1 on hf.second_org=os1.org_subjection_id and os1.bsflag='0' left join comm_org_information oi1 on os1.org_id=oi1.org_id and oi1.bsflag='0' left join comm_org_subjection os2 on hf.third_org=os2.org_subjection_id and os2.bsflag='0' left join comm_org_information oi2 on os2.org_id=oi2.org_id and oi2.bsflag='0' left join comm_org_subjection os3 on hf.fourth_org=os3.org_subjection_id and os3.bsflag='0' left join comm_org_information oi3 on os3.org_id=oi3.org_id and oi3.bsflag='0' where hf.bsflag='0' "+querySqlAdd+" and hf.project_name like '%"+name+"%' order by hf.modifi_date desc";
			cruConfig.currentPageUrl = "hse/financialResources/financial_list.jsp";
			queryData(1);
		}else{
			refreshData();
		}
	}
	
	function clearQueryText(){
		document.getElementById("name").value = "";
	}
	
	
	function ifPassFlag(){
		var pass_flag = document.getElementById("pass_flag").value;
		if(pass_flag=="0"){
			document.getElementById("ifPassFlag").style.display = "";
			document.getElementById("pass_date").value = "<%=today %>";
		}else{
			document.getElementById("ifPassFlag").style.display = "none";
			document.getElementById("pass_date").value = "";
		}
	}
	
	function ifPlanFlag(){
		var hse_financial_id = document.getElementById("hse_financial_id").value;
		var plan_flag = document.getElementById("plan_flag").value;
		if(hse_financial_id==""){
			alert("请先选中一条记录!");
	     	return;
		}
		var retObj = jcdpCallService("HseSrv", "queryFinancial", "hse_financial_id="+hse_financial_id);
		if(plan_flag=="0"){
			document.getElementById("second_org22").value = retObj.list[0].secondOrg;
			document.getElementById("third_org22").value = retObj.list[0].thirdOrg;
			document.getElementById("fourth_org22").value = retObj.list[0].fourthOrg;
			document.getElementById("second_org222").value = retObj.list[0].secondOrgName;
			document.getElementById("third_org222").value = retObj.list[0].thirdOrgName;
			document.getElementById("fourth_org222").value = retObj.list[0].fourthOrgName;
			document.getElementById("project_name22").value = retObj.list[0].projectName;
			document.getElementById("input_money").value = retObj.list[0].planMoney;
			
			changeMoney();
		}else{
			document.getElementById("second_org22").value = "";
			document.getElementById("third_org22").value = "";
			document.getElementById("fourth_org22").value = "";
			document.getElementById("second_org222").value = "";
			document.getElementById("third_org222").value = "";
			document.getElementById("fourth_org222").value = "";
			document.getElementById("project_name22").value = "";
			document.getElementById("input_money").value = "";
			document.getElementById("gap_money").value = "";
		}
	}
	
	function showMoneySource(){
		var selected = window.showModalDialog("<%=contextPath%>/hse/financialResources/selectMoneySource.jsp","","dialogWidth=545px;dialogHeight=280px");

		var source_name = "";
		var name = ""
		var temp = selected.split("、");
		for(var i=0;i<temp.length;i++){
			var id = temp[i];
			if(id=="1"){
				name = "集团公司";		
			}
			if(id=="2"){
				name = "公司";		
			}
			if(id=="3"){
				name = "二级单位";		
			}
			if(id=="4"){
				name = "基层单位";		
			}
			if(source_name!="") source_name += "、";
			source_name += name;
		}
		document.getElementById("money_source").value = selected;
		document.getElementById("source_name").value = source_name;
		
	}
	
	function changeMoney(){
		var input_money = document.getElementById("input_money").value;
		var plan_money = document.getElementById("plan_money").value;
		input_money = Number(input_money);
		plan_money = Number(plan_money);
		document.getElementById("gap_money").value=input_money-plan_money;
	}
	
	function totalMoney(){
		var re = /^[0-9]+\.?[0-9]*$/;   //判断字符串是否为数字     //判断正整数 /^[1-9]+[0-9]*]*$/  
		var money0 = document.getElementById("money0").value;
		var money1 = document.getElementById("money1").value;
		var money2 = document.getElementById("money2").value;
		var money3 = document.getElementById("money3").value;
		document.getElementById("total_money").value = Number(money0)+Number(money1)+Number(money2)+Number(money3);
		if(money0!=""){
			if (!re.test(money0)){
			       alert("资金分配请输入数字！");
			       return true;
			    }
		}
		if(money1!=""){
			if (!re.test(money1)){
			       alert("资金分配请输入数字！");
			       return true;
			    }
		}
		if(money2!=""){
			if (!re.test(money2)){
			       alert("资金分配请输入数字！");
			       return true;
			    }
		}
		if(money3!=""){
			if (!re.test(money3)){
			       alert("资金分配请输入数字！");
			       return true;
			    }
		}
		
	}
	
	function loadDataDetail(shuaId){
		var retObj;
		if(shuaId!=null){
			 retObj = jcdpCallService("HseSrv", "queryFinancial", "hse_financial_id="+shuaId);
			
		}else{
			var ids = getSelIds('rdo_entity_id');
		    if(ids==''){ 
			    alert("请先选中一条记录!");
	     		return;
		    }
		    retObj = jcdpCallService("HseSrv", "queryFinancial", "hse_financial_id="+ids);
		}
		document.getElementById("hse_financial_id").value =retObj.list[0].hseFinancialId;
		document.getElementById("second_org").value =retObj.list[0].secondOrg;
		document.getElementById("third_org").value =retObj.list[0].thirdOrg;
		document.getElementById("fourth_org").value =retObj.list[0].fourthOrg;
		document.getElementById("second_org2").value =retObj.list[0].secondOrgName;
		document.getElementById("third_org2").value =retObj.list[0].thirdOrgName;
		document.getElementById("fourth_org2").value =retObj.list[0].fourthOrgName;
		document.getElementById("project_name").value =retObj.list[0].projectName;
		document.getElementById("plan_money").value = retObj.list[0].planMoney;
		document.getElementById("declare_person").value = retObj.list[0].declarePerson;
		document.getElementById("declare_date").value = retObj.list[0].declareDate;
		var money_source = retObj.list[0].moneySource;
		var selected = document.getElementsByName("selected");
		var source_name = "";
		var name = ""
		var temp = money_source.split("、");
		for(var j=0;j<selected.length;j++){
			selected[j].checked = false;
			for(var i=0;i<temp.length;i++){
				if(temp[i]==selected[j].value){
					selected[j].checked = true;
				}
			}
		}
		document.getElementById("money_source").value = money_source;
		
		document.getElementById("hse_detail_id").value = retObj.list[0].hseDetailId;
		document.getElementById("plan_flag").value = retObj.list[0].planFlag;
		document.getElementById("second_org22").value = retObj.list[0].secondOrg2;
		document.getElementById("third_org22").value = retObj.list[0].thirdOrg2;
		document.getElementById("fourth_org22").value = retObj.list[0].fourthOrg2;
		document.getElementById("second_org222").value = retObj.list[0].secondOrgName2;
		document.getElementById("third_org222").value = retObj.list[0].thirdOrgName2;
		document.getElementById("fourth_org222").value = retObj.list[0].fourthOrgName2;
		document.getElementById("project_name22").value = retObj.list[0].projectName2;
		document.getElementById("input_money").value = retObj.list[0].inputMoney;
		document.getElementById("gap_money").value = retObj.list[0].gapMoney;
		document.getElementById("duty_person").value = retObj.list[0].dutyPerson;
		document.getElementById("complete_date").value = retObj.list[0].completeDate;
		
		document.getElementById("pass_flag").value = retObj.list[0].passFlag;
		document.getElementById("check_person").value = retObj.list[0].checkPerson;
		document.getElementById("pass_date").value = retObj.list[0].passDate;
		document.getElementById("check_describe").value = retObj.list[0].checkDescribe;
		
		
		for(var i=0;i<retObj.list.length;i++){
			document.getElementById("money"+i).value = retObj.list[i].money;
		}
		if(retObj.list.length==1){
			for(var j=0;j<4;j++){
				document.getElementById("money"+j).value = "";
			}
		}
		totalMoney();

		if(retObj.list[0].passFlag=="0"){
			document.getElementById("buttonDis1").style.display = "none";
			document.getElementById("buttonDis2").style.display = "none";
			document.getElementById("buttonDis3").style.display = "none";
		}else{
			document.getElementById("buttonDis1").style.display = "";
			document.getElementById("buttonDis2").style.display = "";
			document.getElementById("buttonDis3").style.display = "";
		}
	}

	var selectedTagIndex = 0;//document.getElementById("tag3_0").parentElement;
	var showTabBox = document.getElementById("tab_box_content0");
	
	
	function toAdd(){
		popWindow("<%=contextPath%>/hse/financialResources/addFinancial.jsp?action=add&isProject=<%=isProject%>");
	}
	
	function toEdit(){
		
		var hse_financial_id = document.getElementById("hse_financial_id").value;
		if(hse_financial_id==""){
			alert("请先选中一条记录!");
	     	return;
		}
		var checkSql = "select * from bgp_hse_financial hf where hf.bsflag='0' and hf.hse_financial_id='"+hse_financial_id+"'";
		var queryRet = syncRequest('Post','<%=request.getContextPath()%>'+appConfig.queryListAction,'querySql='+checkSql+'&&pageSize='+20);
		var datas = queryRet.datas;
		if(datas==null||datas==""){
		}else{
			var pass_flag = datas[0].pass_flag;
			if(pass_flag=="0"){
				alert("该记录验收通过，不能修改！");
				return;
			}else{
				popWindow("<%=contextPath%>/hse/financialResources/addFinancial.jsp?isProject=<%=isProject%>&action=edit&hse_financial_id="+hse_financial_id);
			}
		}
	}
	
	function toUpdate(){
		var hse_financial_id = document.getElementById("hse_financial_id").value;
		var hse_detail_id = document.getElementById("hse_detail_id").value;
		var form = "";
		
		if(hse_financial_id==null||hse_financial_id==""){
			alert("请先选择一条记录!");
			return;
		}
		if(document.getElementById("tab_box_content0").style.display==""||document.getElementById("tab_box_content0").style.display=="block"){
			var ids = "";
			var selected = document.getElementsByName("selected");
			for(var i=0; i<selected.length;i++){
				if(selected[i].checked){
					if(ids!="") ids += "、";
					ids +=selected[i].value;
				}
			}
			document.getElementById("money_source").value = ids ;
			
			if(checkText0()){
				return;
			}
			var form = document.getElementById("form0");
			form.action="<%=contextPath%>/hse/resource/saveFinancial.srq?isProject=<%=isProject%>&hse_financial_id="+hse_financial_id;
		}
		if(document.getElementById("tab_box_content1").style.display==""||document.getElementById("tab_box_content1").style.display=="block"){
			if(checkText1()){
				return;
			}
			var form = document.getElementById("form1");
			form.action="<%=contextPath%>/hse/resource/saveFinancialDetail.srq?isProject=<%=isProject%>&hse_financial_id="+hse_financial_id+"&&hse_detail_id="+hse_detail_id;
		}
		if(document.getElementById("tab_box_content2").style.display==""||document.getElementById("tab_box_content2").style.display=="block"){
			if(checkText2()){
				return;
			}
			var form = document.getElementById("form2");
			form.action="<%=contextPath%>/hse/resource/saveFinancialCheck.srq?isProject=<%=isProject%>&hse_financial_id="+hse_financial_id;
		}
		form.submit();
	} 
	
	function checkText0(){
		var project_name = document.getElementById("project_name").value;
		var plan_money = document.getElementById("plan_money").value;
		var money_source = document.getElementById("money_source").value;
		var declare_person = document.getElementById("declare_person").value;
		var declare_date = document.getElementById("declare_date").value;
		var re = /^[0-9]+\.?[0-9]*$/;   //判断字符串是否为数字     //判断正整数 /^[1-9]+[0-9]*]*$/  
		
		if(project_name==""){
			alert("项目不能为空，请填写！");
			return true;
		}
		if(plan_money==""){
			alert("计划所需资金不能为空，请填写！");
			return true;
		}else{
			if(!re.test(plan_money)){
			       alert("计划所需资金请输入数字！");
			       return true;
			    }
		}
		if(money_source==""){
			alert("资金来源不能为空，请选择！");
			return true;
		}
		if(declare_person==""){
			alert("申报人不能为空，请填写！");
			return true;
		}
		if(declare_date==""){
			alert("申报日期不能为空，请填写！");
			return true;
		}
		return false;
	}
	
	function checkText1(){
		var plan_flag = document.getElementById("plan_flag").value;
		var project_name22 = document.getElementById("project_name22").value;
		var input_money = document.getElementById("input_money").value;
		var gap_money = document.getElementById("gap_money").value;
		var complete_date = document.getElementById("complete_date").value;
		var duty_person = document.getElementById("duty_person").value;
		var total_money = document.getElementById("total_money").value;
		var re = /^\-?[0-9]+\.?[0-9]*$/;   //判断字符串是否为数字     //判断正整数 /^[1-9]+[0-9]*]*$/  
		
		if(plan_flag==""){
			alert("是否计划内不能为空，请选择！");
			return true;
		}
		if(project_name22==""){
			alert("项目名称不能为空，请填写！");
			return true;
		}
		if(input_money==""){
			alert("投入资金不能为空，请选择！");
			return true;
		}else{
			if(!re.test(input_money)){
			       alert("投入资金请输入数字！");
			       return true;
			    }
		}
		if(gap_money!=""){
			if(!re.test(gap_money)){
			       alert("与计划资金差额请输入数字！");
			       return true;
			    }
		}
		if(complete_date==""){
			alert("项目完成时间不能为空，请填写！");
			return true;
		}
		if(duty_person==""){
			alert("负责人不能为空，请填写！");
			return true;
		}
		if(total_money!=input_money){
			alert("资金分配错误，资金分配合计应与投入资金相等！");
			return true;
		}
		return false;
	}
	
	function checkText2(){
		var pass_flag = document.getElementById("pass_flag").value;
		var check_person = document.getElementById("check_person").value;
		var check_describe = document.getElementById("check_describe").value;
		
		if(pass_flag==""){
			alert("验收意见不能为空，请选择！");
			return true;
		}
		if(check_person==""){
			alert("验收人不能为空，请填写！");
			return true;
		}
		if(check_describe==""){
			alert("验收内容描述不能为空，请填写！");
			return true;
		}
		return false;
	}

	function toDelete(){
 		
	    ids = getSelIds('rdo_entity_id');
	    if(ids==''){ alert("请先选中一条记录!");
	     	return;
	    }	
	    debugger;
	    var temp = ids.split(",");
	    for(var i=0;i<temp.length;i++){
		    var checkSql = "select * from bgp_hse_financial hf where hf.bsflag='0' and hf.hse_financial_id='"+temp[i]+"'";
			var queryRet = syncRequest('Post','<%=request.getContextPath()%>'+appConfig.queryListAction,'querySql='+checkSql+'&&pageSize='+20);
			var datas = queryRet.datas;
			if(datas==null||datas==""){
			}else{
				var pass_flag = datas[0].pass_flag;
				if(pass_flag=="0"){
					alert("该记录验收通过，不能删除！");
					return;
				}
			}
	    }
	    
		if(confirm('确定要删除吗?')){  
			var retObj = jcdpCallService("HseSrv", "deleteFinancial", "hse_financial_id="+ids);
			queryData(cruConfig.currentPage);
		}
	}

	function toSearch(){
		popWindow("<%=contextPath%>/hse/financialResources/financial_search.jsp?isProject=<%=isProject%>");
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
	
	function selectOrg4(){
	    var teamInfo = {
	        fkValue:"",
	        value:""
	    };
	    window.showModalDialog('<%=contextPath%>/common/selectOrgSub.jsp',teamInfo);
	    if(teamInfo.fkValue!=""){
	    	document.getElementById("second_org22").value = teamInfo.fkValue;
	        document.getElementById("second_org222").value = teamInfo.value;
	    }
	}

	function selectOrg5(){
	    var teamInfo = {
	        fkValue:"",
	        value:""
	    };
	    var second = document.getElementById("second_org22").value;
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
			    	 document.getElementById("third_org22").value = teamInfo.fkValue;
			        document.getElementById("third_org222").value = teamInfo.value;
				}
	   
	}

	function selectOrg6(){
	    var teamInfo = {
	        fkValue:"",
	        value:""
	    };
	    var third = document.getElementById("third_org22").value;
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
			    	 document.getElementById("fourth_org22").value = teamInfo.fkValue;
			        document.getElementById("fourth_org222").value = teamInfo.value;
				}
	}
	
	
</script>

</html>


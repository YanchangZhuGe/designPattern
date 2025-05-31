<%@page import="com.bgp.gms.service.rm.em.pojo.BgpCommHumanCostreport"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@ page contentType="text/html;charset=utf-8" language="java"
	pageEncoding="utf-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@taglib prefix="auth" uri="auth"%>
<%@ page import="java.util.*"%>
<%@ page import="com.cnpc.jcdp.soa.msg.MsgElement"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String userName = (user == null) ? "" : user.getEmpId();
	SimpleDateFormat format = new SimpleDateFormat("yyyy-MM");
	String curDate = format.format(new Date());
	
	ISrvMsg resultMsg = OMSMVCUtil.getResponseMsg(request);
	
	BgpCommHumanCostreport applyInfo = (BgpCommHumanCostreport) resultMsg
	.getMsgElement("applyInfo").toPojo(
			BgpCommHumanCostreport.class);
	
	List<MsgElement> list = resultMsg.getMsgElements("list");
	List<MsgElement> endlist = resultMsg.getMsgElements("endlist");
	String view = resultMsg.getValue("view");
	
	int fysize = 0;
	int emsize = 0;
	if(list != null && list.size()>0){
		fysize = list.size();
	}
	if(endlist != null && endlist.size()>0){
		emsize = endlist.size();
	}


%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet"
	type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css"
	rel="stylesheet" type="text/css" />
<link rel="stylesheet" type="text/css"
	href="<%=contextPath%>/css/cn/style.css" />

<!--Remark JavaScript定义-->
<script type="text/JavaScript">


function calMonthSelector(inputField,tributton)
{    
    Calendar.setup({
        inputField     :    inputField,   // id of the input field
        ifFormat       :    "%Y-%m",       // format of the input field
        align          :    "Br",
		button         :    tributton,
        onUpdate       :    null,
        weekNumbers    :    false,
		singleClick    :    false,
		step	       :	1
    });
}

function savereport(){

	var form = document.getElementById("CheckForm");
	form.action = "<%=contextPath%>/rm/em/toSaveHumanCostReport.srq";
	form.submit();
	newClose();
}
</script>
<script type="text/JavaScript" src="/BGPMCS/js/calendar-zh.js"></script>
	<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
	<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
  <link rel="stylesheet" type="text/css" href="<%=contextPath%>/css/cn/style.css" /> 
  <link href="<%=contextPath%>/css/common.css" rel="stylesheet" type="text/css" /> 
  <link href="<%=contextPath%>/css/main.css" rel="stylesheet" type="text/css" /> 
  <link href="<%=contextPath%>/css/rt_cru.css" rel="stylesheet" type="text/css" /> 
  <link rel="stylesheet" href="<%=contextPath%>/skin/cute/style/style.css" type="text/css" /> 
  <link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" /> 
  <link rel="stylesheet" type="text/css" href="<%=contextPath%>/css/cn/jquery_ui/jquery.ui.all.css" /> 
  <script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script> 
  <script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script> 
  <script type="text/javascript" src="<%=contextPath%>/js/table.js"></script> 
  <script type="text/javascript" src="<%=contextPath%>/js/ui/jquery.ui.core.js"></script> 
  <script type="text/javascript" src="<%=contextPath%>/js/ui/jquery.ui.widget.js"></script> 
  <script type="text/javascript" src="<%=contextPath%>/js/ui/jquery.ui.mouse.js"></script> 
  <script type="text/javascript" src="<%=contextPath%>/js/ui/jquery.ui.datepicker.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/rt/rt_cru.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/cn/rt_cru_lan.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/rt/proc_base.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/rt/fujian.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/rt/rt_validate.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/cn/rt_validate_lan.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/rt/rt_edit.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/json.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/rt/ui_dyAdd.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>

<style type="text/css"> body{ font-size:15px; } </style>

</head>
<body onload="" style="overflow-y: auto">
<form id="CheckForm" action="" method="post" target="list" enctype="multipart/form-data">
<input type="hidden" id="fysize" name="fysize" value="<%=fysize%>"/>
<input type="hidden" id="emsize" name="emsize" value="<%=emsize%>"/>
<input type="hidden" id="reportId" name="reportId" value="<%=applyInfo.getReportId()==null?"":applyInfo.getReportId()%>"/>
	<div id="inq_tool_box">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td width="6"><img src="<%=contextPath%>/images/list_13.png"
					width="6" height="36" />
				</td>
				<td background="<%=contextPath%>/images/list_15.png"><table
						width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr>
							<td class="ali_cdn_name" width="20%">日期</td>
							<td width="20%"><input name="applyDate" id="applyDate"
								class="input_width" value="<%=applyInfo.getApplyDate()==null?"":applyInfo.getApplyDate()%>" type="text"
								readonly="readonly" /> <img
								src="<%=contextPath%>/images/calendar.gif" id="tributton1"
								width="16" height="16" style="cursor: hand;"
								onmouseover="calMonthSelector(applyDate,tributton1);" /></td>
							<td class="ali_cdn_name" width="20%">申请单号</td>
							<td width="20%"><input name="reportNo" id="reportNo"
								class="input_width" style="color: gray;" value="<%=applyInfo.getReportNo()==null?"申请提交后系统自动生成":applyInfo.getReportNo()%>" type="text"
								readonly="readonly" /> </td>
							<td><span class="cx"><a href="#"
									onclick="simpleSearch()" title="JCDP_btn_query"></a>
							</span>
							</td>

						</tr>
					</table></td>
				<td width="4"><img src="<%=contextPath%>/images/list_17.png"
					width="4" height="36" />
				</td>
			</tr>
		</table>
	</div>
	<div style="border: 1px #aebccb solid; background: #f1f2f3; padding: 10px; width: 98%">

		<table width="99%" id="lineTable" border="1" cellspacing="0" cellpadding="0" align="center">
		    <tr align="center"><td colspan="16">东方地球物理公司一线项目（境内）工资总额及劳务费情况表</td></tr>
			<tr align="center">
				<td rowspan="2">序号</td>
				<td rowspan="2">单位名称</td>
				<td colspan="6">平均人数</td>
				<td colspan="6">工资总额及劳务费情况</td>
				<td colspan="2">采集项目情况</td>
			</tr>
			<tr align="center">
				<td>合计</td>
				<td>合同化员工</td>
				<td>市场化用工</td>
				<td>临时季节性用工</td>
				<td>劳务用工</td>
				<td>再就业人员</td>
				<td>合计</td>
				<td>合同化员工</td>
				<td>市场化用工</td>
				<td>临时季节性用工</td>
				<td>劳务用工</td>
				<td>再就业人员</td>
				<td>采集项目定额施工月</td>
				<td>采集项目实际施工月</td>
			</tr>

			<tr align="center">
				<td>甲</td>
				<td>1</td>
				<td>8</td>
				<td>9</td>
				<td>10</td>
				<td>11</td>
				<td>12</td>
				<td>13</td>
				<td>14</td>
				<td>15</td>
				<td>16</td>
				<td>17</td>
				<td>18</td>
				<td>19</td>
				<td>20</td>
				<td>21</td>
			</tr>
			<tr align="center">
				<td colspan="2">合计</td>
				<td><input type="text" id="sum3_1" class="input_width_list"  value="" readonly="readonly"/>&nbsp;</td>
				<td><input type="text" id="sum3_2" class="input_width_list"  value="" readonly="readonly"/>&nbsp;</td>
				<td><input type="text" id="sum3_3" class="input_width_list"  value="" readonly="readonly"/>&nbsp;</td>
				<td><input type="text" id="sum3_4" class="input_width_list"  value="" readonly="readonly"/>&nbsp;</td>
				<td><input type="text" id="sum3_5" class="input_width_list"  value="" readonly="readonly"/>&nbsp;</td>
				<td><input type="text" id="sum3_6" class="input_width_list"  value="" readonly="readonly"/>&nbsp;</td>
				<td><input type="text" id="sum3_7" class="input_width_list"  value="" readonly="readonly"/>&nbsp;</td>
				<td><input type="text" id="sum3_8" class="input_width_list"  value="" readonly="readonly"/>&nbsp;</td>
				<td><input type="text" id="sum3_9" class="input_width_list"  value="" readonly="readonly"/>&nbsp;</td>
				<td><input type="text" id="sum3_10" class="input_width_list"  value="" readonly="readonly"/>&nbsp;</td>
				<td><input type="text" id="sum3_11" class="input_width_list"  value="" readonly="readonly"/>&nbsp;</td>
				<td><input type="text" id="sum3_12" class="input_width_list"  value="" readonly="readonly"/>&nbsp;</td>
				<td>—</td>
				<td>—</td>
			</tr>
			<tr align="center">
				<td align="left">一</td>
				<td align="left">项目</td>
				<td><input type="text" id="sum1_1" class="input_width_list"  value="" readonly="readonly"/>&nbsp;</td>
				<td><input type="text" id="sum1_2" class="input_width_list"  value="" readonly="readonly"/>&nbsp;</td>
				<td><input type="text" id="sum1_3" class="input_width_list"  value="" readonly="readonly"/>&nbsp;</td>
				<td><input type="text" id="sum1_4" class="input_width_list"  value="" readonly="readonly"/>&nbsp;</td>
				<td><input type="text" id="sum1_5" class="input_width_list"  value="" readonly="readonly"/>&nbsp;</td>
				<td><input type="text" id="sum1_6" class="input_width_list"  value="" readonly="readonly"/>&nbsp;</td>
				<td><input type="text" id="sum1_7" class="input_width_list"  value="" readonly="readonly"/>&nbsp;</td>
				<td><input type="text" id="sum1_8" class="input_width_list"  value="" readonly="readonly"/>&nbsp;</td>
				<td><input type="text" id="sum1_9" class="input_width_list"  value="" readonly="readonly"/>&nbsp;</td>
				<td><input type="text" id="sum1_10" class="input_width_list"  value="" readonly="readonly"/>&nbsp;</td>
				<td><input type="text" id="sum1_11" class="input_width_list"  value="" readonly="readonly"/>&nbsp;</td>
				<td><input type="text" id="sum1_12" class="input_width_list"  value="" readonly="readonly"/>&nbsp;</td>
				<td>—</td>
				<td>—</td>
			</tr>
		<%
		if(list != null && list.size() > 0){

		for (int i = 0; i < list.size(); i++) {
			String className = "";
			if (i % 2 == 1) {
				className = "odd";
			} else {
				className = "even";
			}
			Map map = list.get(i).toMap();

		%>	
			<tr class="<%=className%>">
				<td><%=i+1 %></td>
				<td width="15%"><input type="hidden"  readonly="readonly" id="fy<%=i%>projectInfoNo" name="fy<%=i%>projectInfoNo" class="input_width_list"  value="<%=map.get("projectInfoNo")%>"/>
				<input type="text"  readonly="readonly" id="fy<%=i%>projectName" name="fy<%=i%>projectName" class="input_width_list"  value="<%=map.get("projectName")%>"/>
				<input type="hidden"  readonly="readonly" id="fy<%=i%>projectState" name="fy<%=i%>projectState"  value="0"/></td>
				<td><input type="text"   readonly="readonly" id="fy<%=i%>sumNum" name="fy<%=i%>sumNum" class="input_width_list" value="<%=map.get("sumNum") %>"/></td>
				<td><input type="text"   readonly="readonly" id="fy<%=i%>contNum" name="fy<%=i%>contNum" class="input_width_list"  value="<%=map.get("contNum")%>"/></td>
				<td><input type="text"   readonly="readonly" id="fy<%=i%>markNum" name="fy<%=i%>markNum" class="input_width_list"  value="<%=map.get("markNum")%>"/></td>
				<td><input type="text"   readonly="readonly" id="fy<%=i%>tempNum" name="fy<%=i%>tempNum" class="input_width_list"  value="<%=map.get("tempNum")%>"/></td>
				<td><input type="text"   readonly="readonly" id="fy<%=i%>reemNum" name="fy<%=i%>reemNum" class="input_width_list"  value="<%=map.get("reemNum")%>"/></td>
				<td><input type="text"   readonly="readonly" id="fy<%=i%>servNum" name="fy<%=i%>servNum" class="input_width_list"  value="<%=map.get("servNum")%>"/></td>
				<td><input type="text"   readonly="readonly" id="fy<%=i%>sumCost" name="fy<%=i%>sumCost" class="input_width_list"  value="<%=map.get("sumCost")%>"/></td>
				<td><input type="text"   readonly="readonly" id="fy<%=i%>contCost" name="fy<%=i%>contCost" class="input_width_list"  value="<%=map.get("contCost")%>"/></td>
				<td><input type="text"   readonly="readonly" id="fy<%=i%>markCost" name="fy<%=i%>markCost" class="input_width_list"  value="<%=map.get("markCost")%>"/></td>
				<td><input type="text"   readonly="readonly" id="fy<%=i%>tempCost" name="fy<%=i%>tempCost" class="input_width_list"  value="<%=map.get("tempCost")%>"/></td>
				<td><input type="text"   readonly="readonly" id="fy<%=i%>reemCost" name="fy<%=i%>reemCost" class="input_width_list"  value="<%=map.get("reemCost")%>"/></td>
				<td><input type="text"   readonly="readonly" id="fy<%=i%>servCost" name="fy<%=i%>servCost" class="input_width_list"  value="<%=map.get("servCost")%>"/></td>				
				<td><input type="text"   readonly="readonly" id="fy<%=i%>constMonth" name="fy<%=i%>constMonth" class="input_width_list"  value="<%=map.get("constMonth")%>"/></td>
				<td>—</td>
			</tr>
		<%} 			
		}%>
		
			<tr align="center">
				<td align="left">二</td>
				<td align="left">已完工项目</td>
				<td><input type="text"   readonly="readonly" id="sum2_1" class="input_width_list"  value=""/>&nbsp;</td>
				<td><input type="text"   readonly="readonly" id="sum2_2" class="input_width_list"  value=""/>&nbsp;</td>
				<td><input type="text"   readonly="readonly" id="sum2_3" class="input_width_list"  value=""/>&nbsp;</td>
				<td><input type="text"   readonly="readonly" id="sum2_4" class="input_width_list"  value=""/>&nbsp;</td>
				<td><input type="text"   readonly="readonly" id="sum2_5" class="input_width_list"  value=""/>&nbsp;</td>
				<td><input type="text"   readonly="readonly" id="sum2_6" class="input_width_list"  value=""/>&nbsp;</td>
				<td><input type="text"   readonly="readonly" id="sum2_7" class="input_width_list"  value=""/>&nbsp;</td>
				<td><input type="text"   readonly="readonly" id="sum2_8" class="input_width_list"  value=""/>&nbsp;</td>
				<td><input type="text"   readonly="readonly" id="sum2_9" class="input_width_list"  value=""/>&nbsp;</td>
				<td><input type="text"   readonly="readonly" id="sum2_10" class="input_width_list"  value=""/>&nbsp;</td>
				<td><input type="text"   readonly="readonly" id="sum2_11" class="input_width_list"  value=""/>&nbsp;</td>
				<td><input type="text"   readonly="readonly" id="sum2_12" class="input_width_list"  value=""/>&nbsp;</td>
				<td>—</td>
				<td>—</td>
			</tr>
	   <%
		if(endlist != null && endlist.size() > 0){
		
		int j = (list!=null && list.size()>0)?list.size():0;
		for (int i = 0; i < endlist.size(); i++) {
			String className = "";
			if (i % 2 == 1) {
				className = "odd";
			} else {
				className = "even";
			}
			Map map = endlist.get(i).toMap();

		%>	
			<tr class="<%=className%>">
				<td><%=i+1+j %></td>				
				<td width="15%"><input type="hidden"   readonly="readonly" id="em<%=i%>projectInfoNo" name="em<%=i%>projectInfoNo" class="input_width_list"  value="<%=map.get("projectInfoNo")%>"/>
				<input type="text"   readonly="readonly" id="em<%=i%>projectName" name="em<%=i%>projectName" class="input_width_list"  value="<%=map.get("projectName")%>"/>
				<input type="hidden"   readonly="readonly" id="em<%=i%>projectState" name="em<%=i%>projectState"  value="1"/></td>
				<td><input type="text"   readonly="readonly" id="em<%=i%>sumNum" name="em<%=i%>sumNum" class="input_width_list"  value="<%=map.get("sumNum") %>"/></td>
				<td><input type="text"   readonly="readonly" id="em<%=i%>contNum" name="em<%=i%>contNum" class="input_width_list"  value="<%=map.get("contNum")%>"/></td>
				<td><input type="text"   readonly="readonly" id="em<%=i%>markNum" name="em<%=i%>markNum" class="input_width_list"  value="<%=map.get("markNum")%>"/></td>
				<td><input type="text"   readonly="readonly" id="em<%=i%>tempNum" name="em<%=i%>tempNum" class="input_width_list"  value="<%=map.get("tempNum")%>"/></td>
				<td><input type="text"   readonly="readonly" id="em<%=i%>reemNum" name="em<%=i%>reemNum" class="input_width_list"  value="<%=map.get("reemNum")%>"/></td>
				<td><input type="text"   readonly="readonly" id="em<%=i%>servNum" name="em<%=i%>servNum" class="input_width_list"  value="<%=map.get("servNum")%>"/></td>
				<td><input type="text"   readonly="readonly" id="em<%=i%>sumCost" name="em<%=i%>sumCost" class="input_width_list"  value="<%=map.get("sumCost")%>"/></td>
				<td><input type="text"   readonly="readonly" id="em<%=i%>contCost" name="em<%=i%>contCost" class="input_width_list"  value="<%=map.get("contCost")%>"/></td>
				<td><input type="text"   readonly="readonly" id="em<%=i%>markCost" name="em<%=i%>markCost" class="input_width_list"  value="<%=map.get("markCost")%>"/></td>
				<td><input type="text"   readonly="readonly" id="em<%=i%>tempCost" name="em<%=i%>tempCost" class="input_width_list"  value="<%=map.get("tempCost")%>"/></td>
				<td><input type="text"   readonly="readonly" id="em<%=i%>reemCost" name="em<%=i%>reemCost" class="input_width_list"  value="<%=map.get("reemCost")%>"/></td>
				<td><input type="text"   readonly="readonly" id="em<%=i%>servCost" name="em<%=i%>servCost" class="input_width_list"  value="<%=map.get("servCost")%>"/></td>				
				<td><input type="text"   readonly="readonly" id="em<%=i%>constMonth" name="em<%=i%>constMonth" class="input_width_list"  value="<%=map.get("constMonth")%>"/></td>
				<td><input type="text"   readonly="readonly" id="em<%=i%>actMonth" name="em<%=i%>actMonth" class="input_width_list"  value="<%=map.get("actMonth")%>"/></td>				
			</tr>
		<%} 			
		}%>
			
		</table>

	</div>
    <div id="oper_div">
       <%if(!"true".equals(view)){ %>
        	<span class="bc_btn"><a href="#" onclick="savereport()"></a></span>
       <%} %>    
        <span class="gb_btn"><a href="#" onclick="newClose()"></a></span>
    </div>
</form>
</body>
</html>

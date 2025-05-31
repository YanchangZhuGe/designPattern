<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@ page import="java.util.*"%>
<%@ page import="com.cnpc.jcdp.soa.msg.MsgElement"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	ISrvMsg resultMsg = OMSMVCUtil.getResponseMsg(request);
	String project_info_no = user.getProjectInfoNo();
	if(project_info_no == null){
		project_info_no = "";
	}
	String project_name = user.getProjectName();
	if(project_name == null){
		project_name = "";
	}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<link href="<%=contextPath%>/css/calendar-blue.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/common.js"></script>
<script type="text/JavaScript" src="<%=contextPath%>/js/calendar-zh.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<script type="text/javascript" >
	var checked = false;
	function check(){
		var chk = document.getElementsByName("chk_entity_id");
		for(var i = 0; i < chk.length; i++){ 
			if(!checked){ 
				chk[i].checked = true; 
			}
			else{
				chk[i].checked = false;
			}
		} 
		if(checked){
			checked = false;
		}
		else{
			checked = true;
		}
	}
	function yymmSelector(inputField,tributton)
	{    
	    Calendar.setup({
	        inputField     :    inputField,   // id of the input field
	        ifFormat       :    "%Y-%m",       // format of the input field
	        align          :    "Br",
			button         :    tributton,
	        onUpdate       :    null,
	        weekNumbers    :    false,
			singleClick    :    true,
			step	       :	1
	    });
	}
</script>
<title>列表页面</title>
</head>
<body style="background:#fff">
	<div id="inq_tool_box">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td width="8"><img src="<%=contextPath %>/images/list_13.png" width="8" height="36" /></td>
				<td background="<%=contextPath %>/images/list_15.png">
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr>
							<td class="ali_cdn_name">汇总时间</td>
							<td class="ali_cdn_input"><input id="report_date" name="report_date" type="text" class="input_width" disabled="disabled"/></td>
							<td class='ali_btn'><img width="16" height="16" id="cal_button7" style="cursor: hand;" onmouseover="yymmSelector(report_date,cal_button7);"  src="<%=contextPath %>/images/calendar.gif" /></td>
							<auth:ListButton functionId="" css="cx" event="onclick='refreshData()'" title="JCDP_btn_submit"></auth:ListButton>
							<auth:ListButton functionId="" css="qc" event="onclick='clearQueryText()'" title="JCDP_btn_clear"></auth:ListButton>
						 	<td>&nbsp;</td>
						 	<auth:ListButton functionId="" css="ck" event="onclick='toView()'" title="JCDP_btn_view"></auth:ListButton> 
						    <%-- <auth:ListButton functionId="" css="dc" event="onclick='exportData()'" title="JCDP_btn_export"></auth:ListButton> --%>
						</tr>
					</table>
				</td>
			</tr>
		</table>
	</div>
	<div id="table_box" >
		<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">
			<tr>
			  <td class="bt_info_odd" exp="<input type='checkbox' name='chk_entity_id' value='{accident_id}' onclick=check(this)/>" >
			  	<input type='checkbox' name='chk_entity_id' value='' onclick='check(this)'/></td>
			  <td class="bt_info_even" autoOrder="1">序号</td> 
			  <td class="bt_info_odd" exp="{org_name}">填报单位</td>
			  <td class="bt_info_even" exp="{report_date}">填报日期</td>
			  <td class="bt_info_odd" exp="{accident_num}">质量事故次数</td>
			</tr>
		</table>
	</div> 
	<div id="fenye_box">
		<table width="100%" border="0" cellspacing="0" cellpadding="0" id="fenye_box_table">
		  <tr>
		    <td align="right">第1/1页，共0条记录</td>
		    <td width="10">&nbsp;</td>
		    <td width="30"><img src="<%=contextPath %>/images/fenye_01.png" width="20" height="20" /></td>
		    <td width="30"><img src="<%=contextPath %>/images/fenye_02.png" width="20" height="20" /></td>
		    <td width="30"><img src="<%=contextPath %>/images/fenye_03.png" width="20" height="20" /></td>
		    <td width="30"><img src="<%=contextPath %>/images/fenye_04.png" width="20" height="20" /></td>
		    <td width="50">到 
		      <label>
		        <input type="text" name="changePage" id="changePage" style="width:20px;" />
		      </label></td>
		    <td align="left"><img src="<%=contextPath %>/images/fenye_go.png" width="22" height="22" onclick="changePage()"/></td>
		  </tr>
		</table>
	</div>
<script type="text/javascript">
	cruConfig.contextPath =  "<%=contextPath%>";
	cruConfig.cdtType = 'form';
	cruConfig.queryStr = "";
	cruConfig.queryService = "QualityItemsSrv";
	cruConfig.queryOp = "getAccidentList";
	function refreshData(){
		var report_date = document.getElementById("report_date").value;
		if(report_date!=null && report_date!=''){
			cruConfig.submitStr = "status=report&report_date="+report_date;
		}else{
			cruConfig.submitStr = "status=report";
		}
		queryData(1);
	}
	refreshData();
	/* 详细信息 */
	function loadDataDetail(id){
		var obj = event.srcElement; 
    	if(obj.tagName.toLowerCase() == "td"){   
    		var   tr   =  obj.parentNode ;
    		tr.cells[0].firstChild.checked = true;
    	} 
	}
	function clearQueryText(){
		document.getElementById("report_date").value = "";
	}
	function toView() {
		var obj = document.getElementsByName("chk_entity_id");
		var objLen= obj.length; 
		var accident_id = '';
		for (var i = 1;i< objLen-1 ;i++){   
		    if (obj [i].checked==true) { 
		    	accident_id=obj [i].value;
				popWindow("<%=contextPath%>/qua/dashboard/multiple/accidentView.jsp?accident_id="+accident_id);
				return;
		  	}   
		} 
		alert("请选择记录!")
	}
	function frameSize(){
		$("#table_box").css("height",$(window).height()-$("#inq_tool_box").height()-$("#fenye_box").height()-8);
	}
	frameSize();
	$(function(){
		$(window).resize(function(){
	  		frameSize();
		});
	})

</script>

</body>
</html>

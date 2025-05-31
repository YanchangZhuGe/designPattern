<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@ page import="java.util.*"%>
<%@ page import="com.cnpc.jcdp.soa.msg.MsgElement"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String user_id = user.getUserId();
	if(user_id==null){
		user_id = "";
	}
	String org_id = user.getOrgId();
	if(org_id==null){
		org_id = "";
	}
	String org_subjection_id = user.getSubOrgIDofAffordOrg();
	if(org_subjection_id==null){
		org_subjection_id = "";
	}
	String project_info_no = user.getProjectInfoNo();
	if(project_info_no==null){
		project_info_no = "";
	}
	String project_type = user.getProjectType();
	if(project_type!=null && project_type.trim().equals("5000100004000000002")){
		project_type = "5000100004000000010";
	}
	String name = "评价单炮数量";
	if(project_type!=null && project_type.trim().equals("5000100004000000009")){
		name = "评价数量";
	}
%>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/qua/sProject/summary/summary.js"></script>
<link href="<%=contextPath%>/css/calendar-blue.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/JavaScript" src="<%=contextPath%>/js/calendar-zh.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<style type="text/css">

</style>
<script type="text/javascript" >
	
</script>
<title>无标题文档</title>
</head>
<body style="background:#fff;overflow-y: scroll;">
<div id="list_table">
	<div id="inq_tool_box">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
		  <tr>
		    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
		    <td background="<%=contextPath%>/images/list_15.png">
		    	<table width="100%" border="0" cellspacing="0" cellpadding="0">
				  <tr>
				    <td>&nbsp;</td>
				    <auth:ListButton functionId="F_QUA_CONTROL_003" css="tj" event="onclick='newSubmit()'" title="JCDP_btn_submit"></auth:ListButton>
				  </tr>
				</table>
			</td>
		  </tr>
		</table>
	</div>
	<div id="table_box" > 
		<div id="check"  style="display: block;">
			<table width="100%"  border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
				<tr>
					<td class="inquire_item8">&nbsp;工序名称:</td>
					<td class="inquire_form8" ><input type="text" name="object_name1" id="object_name1" value="" disabled="disabled" class="input_width"/></td>
					<td class="inquire_item8">检查总量:</td>
					<td class="inquire_form8" ><input type="hidden" name="quality_num_old" id="quality_num_old" value="" disabled="disabled" class="input_width"/>
						<input type="text" name="quality_num1" id="quality_num1" value="" readonly="readonly"  class="input_width"/></td>
					<td class="inquire_item8">不合格总量:</td>
					<td class="inquire_form8" ><input type="text" name="summary_num1" id="summary_num1" value="" readonly="readonly"  class="input_width" /></td>
					<td class="inquire_item8">不合格数量占比:</td>
				    <td class="inquire_form8" ><input type="text" name="percent1" id="percent1" value="" disabled="disabled" class="input_width"/></td>   
				</tr>
			</table>
			<table id="summaryTableView" width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info"  >
		    	<tr>
		    		<td class="bt_info_odd"><input type='checkbox' name='summ_entity_id' value='' onclick='check()'/></td>
		    	    <td class="bt_info_even">序号</td>
		            <td class="bt_info_odd">检查项名称</td>
		            <td class="bt_info_even">不合格数量</td>
		            <td class="bt_info_odd">不合格检查项占比</td>
		            <td class="bt_info_even"><label id="unit1" >小组编号</label></td>
		            <td class="bt_info_odd"> 备注</td>
		        </tr>
		   </table>
		   <table width="100%"  border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
				<tr>
					<td class="inquire_item8">检查日期:</td>
					<td class="inquire_form8"><input type="text" name="check_date1" id="check_date1" value="" readonly="readonly"  class="input_width"/> </td>
					<td class="inquire_item8">责任人:</td>
					<td class="inquire_form8"><input type="text" name="checker_name1" id="checker_name1" value="" readonly="readonly" class="input_width"/></td> 
					<td class="inquire_item8">汇总日期:</td>
					<td class="inquire_form8"><input type="text" name="summary_date1" id="summary_date1" value="" readonly="readonly" class="input_width"/></td>
					<td class="inquire_item8">汇总人:</td>
					<td class="inquire_form8"><input type="text" name="summarier1" id="summarier1" value="" readonly="readonly" class="input_width"/></td>
				</tr>
			</table>
		</div>
		<div id="shot" style="display: none;">
			<table width="100%"  border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
				<tr>
					<td class="inquire_item10">&nbsp;&nbsp;&nbsp;<%=name %>:</td>
					<td class="inquire_form10" ><input type="text" name="shot_num1" id="shot_num1" value="" disabled="disabled" class="input_width"/></td>
					<td class="inquire_item10">一级品数量:</td>
					<td class="inquire_form10" ><input type="text" name="first_num1" id="first_num1" value="6340" disabled="disabled" class="input_width"/></td>
					<td class="inquire_item10">二级品数量:</td>
					<td class="inquire_form10" ><input type="text" name="second_num1" id="second_num1" value="0" disabled="disabled" class="input_width" /></td>
					<td class="inquire_item10">一级品率:</td>
				    <td class="inquire_form10" ><input type="text" name="first_percent1" id="first_percent1" value="" disabled="disabled" class="input_width"/></td>   
					<td class="inquire_item10">废品数量:</td>
				    <td class="inquire_form10" ><input type="text" name="abandon_num1" id="abandon_num1" value="8" disabled="disabled" class="input_width"/></td>   
				</tr>
			</table>
			<table id="shotTableView" width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info"  >
		    	<tr>
		    		<td class="bt_info_odd"><input type='checkbox' name='shot_entity_id' value='' onclick='check11()'/></td>
		    	    <td  class="bt_info_even">序号</td>
		            <td  class="bt_info_odd">二级品原因</td>
		            <td class="bt_info_even">二级品数量</td>
		            <td class="bt_info_odd">二级品原因占比</td>
		            <td class="bt_info_even">备注</td>
		        </tr>
	   		</table>
	   		<table width="100%"  border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
				<tr>
					<td class="inquire_item8">评价日期:</td>
					<td class="inquire_form8" ><input type="text" name="evaluate_date1" id="evaluate_date1" value="" readonly="readonly" class="input_width"/></td>
					<td class="inquire_item8">评价人:</td>
					<td class="inquire_form8" ><input type="text" name="evaluate_name1" id="evaluate_name1" value="" readonly="readonly" class="input_width"/></td>
					<td class="inquire_item8">汇总日期:</td>
					<td class="inquire_form8" ><input type="text" name="shot_date1" id="shot_date1" value="" readonly="readonly" class="input_width" /></td>
					<td class="inquire_item8">汇总人:</td>
				    <td class="inquire_form8" ><input type="text" name="shot_name1" id="shot_name1" value="" readonly="readonly" class="input_width"/></td>   
				</tr>
			</table>
		</div>
	</div>
  </div>
  <div class="lashen" id="line"></div>
	<div id="tag-container_3" >
      <ul id="tags" class="tags">
        <li class="selectTag"><a href="#" onclick="getTab(this,1)">常用</a></li>
        <li><a href="#" onclick="getTab(this,2)" >填报</a></li>
        <%if(project_type!=null && project_type.trim().equals("5000100004000000009")){ %>
        	<li style="display: none"><a href="#" onclick="getTab(this,3)" >资料评价</a></li>
        <%}else{ %>
        	<li style="display: none"><a href="#" onclick="getTab(this,3)" >单炮评价</a></li>
        <%} %>
        
        <li ><a href="#" onclick="getTab(this,4)" >填报历史记录</a></li>
      </ul>
    </div>
	<div id="tab_box" class="tab_box" style="overflow:hidden;">
		<div id="tab_box_content1" class="tab_box_content" >
			<div id="usual_check" style="display: block;">
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
				  <tr align="right" >
				    <td>&nbsp;</td>
				    <%-- <auth:ListButton functionId="" css="tj" event="onclick='newSubmit()'" title="JCDP_btn_submit"></auth:ListButton> --%>
				  </tr>
				</table> 
				<form action="" id="form0" name="form0" method="post" >
					<table width="100%"  border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
						<tr>
							<td class="inquire_item8">工序名称:</td>
							<td class="inquire_form8" ><input type="text" name="object_name" id="object_name" value="" disabled="disabled" class="input_width"/></td>
							<td class="inquire_item8"><font color="red">*</font>检查量:</td>
							<td class="inquire_form8" >	<input type="text" name="quality_num" id="quality_num"  value="" class="input_width"
								onfocus="checkIfZero(event)" onkeyup="getSummaryNum()" onkeydown="javascript:return checkIfNum(event);"/></td>
							<td class="inquire_item8">不合格数量:</td>
							<td class="inquire_form8" ><input type="text" name="summary_num" id="summary_num" onchange="change('summary_num')" value="" disabled="disabled" class="input_width" /></td>
							<td class="inquire_item8">不合格数量占比:</td>
						    <td class="inquire_form8" ><input type="text" name="percent" id="percent" onchange="change('percent')" value="" disabled="disabled" class="input_width"/></td>  
						</tr>
						<tr>	
						  	<td class="inquire_item8">检查日期:</td>
						    <td class="inquire_form8" ><input type="text" name="check_date" id="check_date" value="" disabled="disabled" class="input_width"/>
							    <img width="16" height="16" id="cal_button6" style="cursor: hand;" onmouseover="calDateSelector(check_date,cal_button6);" src="<%=contextPath %>/images/calendar.gif" /></td>
						  	<td class="inquire_item8">责任人:</td>
						    <td class="inquire_form8" ><input name="checker_name" id="checker_name" type="text" class="input_width" value="" disabled="disabled" /></td> 
						    <td class="inquire_item8">汇总日期:</td>
						    <td class="inquire_form8" ><input type="text" name="summary_date" id="summary_date" value="" disabled="disabled" class="input_width"/>
						    	<img width="16" height="16" id="cal_button7" style="cursor: hand;" onmouseover="calDateSelector(summary_date,cal_button7);" src="<%=contextPath %>/images/calendar.gif" /></td>
						   	<td class="inquire_item8">汇总人:</td>
						   	<td class="inquire_form8"><input type="text" name="summarier" id="summarier"  value="" class="input_width"/></td>
				  		</tr>
					</table>
				</form>	
			</div>
			<div id="usual_shot" style="display:none;">
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
				  <tr align="right" >
				    <td>&nbsp;</td>
				    <%-- <auth:ListButton functionId="" css="tj" event="onclick='newSubmit()'" title="JCDP_btn_submit"></auth:ListButton> --%>
				  </tr>
				</table> 
				<form action="" id="form1" name="form1" method="post" >
					<table width="100%"  border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
						<tr>
							<td class="inquire_item8" ><%=name %>:</td>
							<td class="inquire_form8" ><input type="text" name="shot_num" id="shot_num"  value="0" class="input_width" 
							<%if(project_type!=null && project_type.trim().equals("5000100004000000009")){}else{ %>disabled="disabled"<%} %>/></td>
							<td class="inquire_item8">一级品数量:</td>
							<td class="inquire_form8" ><input type="text" name="first_num" id="first_num" value="" class="input_width"
								onfocus="checkIfZero(event)" onkeyup="showFirstPercent()" onkeydown="javascript:return checkIfNum(event);"/></td>
							<td class="inquire_item8">二级品数量:</td>
							<td class="inquire_form8" ><input type="text" name="second_num" id="second_num" value="0" class="input_width" disabled="disabled"/></td>
							<!-- <td class="inquire_item8">一级品率:</td>
						    <td class="inquire_form8" ><input type="text" name="first_percent" id="first_percent" value="" disabled="disabled" class="input_width"/></td> -->   
							<td class="inquire_item8">废品数量:</td>
						    <td class="inquire_form8" ><input type="text" name="abandon_num" id="abandon_num" onkeyup="showFirstPercent()" value="" class="input_width" 
						    	onfocus="checkIfZero(event)" onkeydown="javascript:return checkIfNum(event);"/></td>  
						</tr>
						<tr>
							<td class="inquire_item8">评价日期:</td>
							<td class="inquire_form8" ><input type="text" name="evaluate_date" id="evaluate_date" value="" disabled="disabled" class="input_width"/>
								<img width="16" height="16" id="cal_button8" style="cursor: hand;" 
									onmouseover="calDateSelector(evaluate_date,cal_button8);" src="<%=contextPath %>/images/calendar.gif" /></td>
							<td class="inquire_item8">评价人:</td>
							<td class="inquire_form8" ><input type="text" name="evaluate_id" id="evaluate_id" value="" class="input_width" /></td>
						   <td class="inquire_item8">汇总日期:</td>
							<td class="inquire_form8" ><input  type="text" name="shot_date" id="shot_date" value="" disabled="disabled" class="input_width" />
								<img width="16" height="16" id="cal_button9" style="cursor: hand;" 
									onmouseover="calDateSelector(shot_date,cal_button9);" src="<%=contextPath %>/images/calendar.gif" /></td>
							<td class="inquire_item8">汇总人:</td>
						    <td class="inquire_form8" ><input type="text" name="shot_id" id="shot_id" value="" class="input_width"/></td>
						</tr>
					</table>
				</form>	
			</div>
		</div>
		
		<div id="tab_box_content2" class="tab_box_content" style="display:none;"> 
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr align="right" >
			    <td>&nbsp;</td>
			  </tr>
			</table>
			<table id="summaryTable" width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info"  >
		    	<tr>
		    		<td class="bt_info_odd">
	      				<input type='checkbox' name='summ_entity_id' value='' onclick='check()'/></td>
		    	    <td class="bt_info_even">序号</td>
		            <td class="bt_info_odd">检查项名称</td>
		            <td class="bt_info_even">不合格数量</td>
		            <td class="bt_info_odd">不合格检查项占比</td>
		            <td class="bt_info_even"><label id="unit" >小组编号</label></td>
		            <td class="bt_info_odd"> 备注</td>
		        </tr>
	   		</table>
		</div>
		<div id="tab_box_content3" class="tab_box_content" style="display:none;">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr align="right" >
			    <td>&nbsp;</td>
			    <%-- <auth:ListButton functionId="" css="tj" event="onclick='toSubmit11()'" title="JCDP_btn_submit"></auth:ListButton> --%>
			  </tr>
			</table> 
			<table id="shotTable" width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info"  >
		    	<tr>
		    		<td class="bt_info_odd"><input type='checkbox' name='shot_entity_id' value='' onclick='check11()'/></td>
		    	    <td  class="bt_info_even">序号</td>
		            <td  class="bt_info_odd">二级品原因</td>
		            <td class="bt_info_even">二级品数量</td>
		            <td class="bt_info_odd">二级品原因占比</td>
		            <td class="bt_info_even">备注</td>
		        </tr>
	   		</table>
		</div>
		<div id="tab_box_content4" class="tab_box_content" style="display:none;">
			<iframe width="100%" height="100%" name="history" id="history" frameborder="0" src="/blank.htm" marginheight="0" marginwidth="0" >
			</iframe>
		</div>
	</div>
<script type="text/javascript">
	cruConfig.contextPath =  "<%=contextPath%>";
	var project_info_no =  "<%=project_info_no%>";
	var user_id =  "<%=user_id%>";
	var org_id =  "<%=org_id%>";
	var org_subjection_id =  "<%=org_subjection_id%>";
	var project_type =  "<%=project_type%>";
	//showSummaryTable(undefined , undefined);//页面初始化
	function historySrc(object_name,task_id,object_id){
		var src = cruConfig.contextPath + "/qua/sProject/summary/summary_history.jsp?object_name="+encodeURI(encodeURI(object_name))+"&task_id="+encodeURI(task_id)+"&object_id="+object_id;
		document.getElementById("history").src = src;
	}
	
	/* 计算详细标签的大小，并可以改变大小 */
	/* function frameSize(){
		setTabBoxHeight();
	}
	frameSize();
	$(function(){
		$(window).resize(function(){
	  		frameSize();
		});
	})	

	$(document).ready(lashen);
	function renderNaviTable(){}
	function lashen() {
		var oLine = $("#line")[0];
		if(oLine==null) return;
		oLine.onmousedown = function(e) {
			var disY = (e || event).clientY;
			oLine.top = oLine.offsetTop;
			document.onmousemove = function(e) {
				var iT = oLine.top + ((e || event).clientY - disY)-70;
				$("#table_box").css("height",iT);
				lashened = 1;
				setTabBoxHeight();
			};
			document.onmouseup = function() {
				document.onmousemove = null;
				document.onmouseup = null;
				oLine.releaseCapture && oLine.releaseCapture()
			};
			oLine.setCapture && oLine.setCapture();
			return false;
		}
	} */
</script>
</body>
</html>

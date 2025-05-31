<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@page import="com.cnpc.jcdp.soa.msg.MsgElement"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="java.util.Date,java.text.SimpleDateFormat"%>
<%@page import="com.cnpc.jcdp.cfg.BeanFactory"%>
<%@page import="java.net.URLDecoder"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
    String userName = (user==null)?"":user.getUserName();
    SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
    String curDate = format.format(new Date());
    ISrvMsg resultMsg = OMSMVCUtil.getResponseMsg(request);
  
    String hse_danger_id = request.getParameter("hse_danger_id");
    
%> 
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title></title>
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels2.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" /> 
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>

</head>
<body>
<form name="form1" id="form1"  method="post" action="<%=contextPath%>/hse/addDangerModify.srq">
<div id="new_table_box">
  <div id="new_table_box_content">
    <div id="new_table_box_bg">
	<table  border="0" cellpadding="0" cellspacing="0" class="tab_line_height" width="100%">
	<input type="hidden" id="hse_danger_id" name="hse_danger_id" value="<%=hse_danger_id%>"></input>
    <tr>
    	<td class="inquire_item6"><font color="red">*</font>整改日期：</td>
      	<td class="inquire_form6"><input type="text" id="modify_time" name="modify_time" class="input_width"  readonly="readonly"/>
      	&nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton1" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(modify_time,tributton1);" />&nbsp;</td>
     	<td class="inquire_item6"><font color="red">*</font>整改状态：</td>
      	<td class="inquire_form6">
      		<select id="modify_type" name="modify_type" class="select_width">
				<option value="" >请选择</option>
			 	<option value="已整改" >已整改</option>
	         	<option value="未整改" >未整改</option>
			</select>
		</td>
		<td class="inquire_item6"><font color="red">*</font>整改负责人：</td>
		<td class="inquire_form6"><input type="text" id="modify_person" name="modify_person" class="input_width" /></td>
    </tr>
    <tr>
		<td class="inquire_item6"><font color="red">*</font>整改验证人：</td>
		<td class="inquire_form6"><input type="text" id="modify_check" name="modify_check" class="input_width" /></td>
		<td class="inquire_item6"></td>
		<td class="inquire_item6"></td>
		<td class="inquire_item6"></td>
		<td class="inquire_item6"></td>
	</tr>	
    <tr>
    	<td class="inquire_item6"><font color="red">*</font>整改措施：</td>
		<td class="inquire_form6" colspan="5"><textarea id="modify_step" name="modify_step" class="textarea"></textarea></td>
	</tr>	
	<tr>
		<td class="inquire_item6"><font color="red">*</font>整改计划：</td>
		<td class="inquire_form6" colspan="5"><textarea id="modify_project" name="modify_project"  class="textarea" ></textarea></td>
	</tr>	
	<tr>
		<td class="inquire_item6"><font color="red">*</font>未整改原因：</td>
		<td class="inquire_form6" colspan="5"><textarea id="modify_no_reason" name="modify_no_reason"  class="textarea"></textarea></td>
	</tr>		
		
</table>
</div>
    <div id="oper_div">
     	<span class="tj_btn"><a href="#" onclick="submitButton()"></a></span>
        <span class="gb_btn"><a href="#" onclick="newClose()"></a></span>
    </div>
</div>
</div> 
</form>
</body>

<script type="text/javascript">
	function submitButton(){
		if(checkText()){
			return;
		};
		document.getElementById("form1").submit();
	}
	
	function checkText(){
		var modify_time=document.getElementById("modify_time").value;
		var modify_type=document.getElementById("modify_type").value;
		var modify_step=document.getElementById("modify_step").value;
		var modify_project=document.getElementById("modify_project").value;
		var modify_no_reason=document.getElementById("modify_no_reason").value;
		if(modify_time==""){
			alert("整改日期不能为空，请填写！");
			return true;
		}
		if(modify_type==""){
			alert("整改状态不能为空，请填写！");
			return true;
		}
		if(modify_step==""){
			alert("整改措施不能为空，请填写！");
			return true;
		}
		if(modify_project==""){
			alert("整改计划不能为空，请填写！");
			return true;
		}
		if(modify_no_reason==""){
			alert("未整改原因不能为空，请填写！");
			return true;
		}
		return false;
	}
</script>
</html>
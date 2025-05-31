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
    System.out.println(hse_danger_id+"^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^");
   
    
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
<form name="form1" id="form1"  method="post" action="<%=contextPath%>/hse/addDangerReward.srq">
<div id="new_table_box">
  <div id="new_table_box_content">
    <div id="new_table_box_bg">
	<table  border="0" cellpadding="0" cellspacing="0" class="tab_line_height" width="100%">
	<input type="hidden" id="hse_danger_id" name="hse_danger_id" value="<%=hse_danger_id%>"></input>
    <tr>
    	<td class="inquire_item6"><font color="red">*</font>奖励日期：</td>
      	<td class="inquire_form6"><input type="text" id="reward_date" name="reward_date" class="input_width" readonly="readonly"/>
      	&nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton1" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(reward_date,tributton1);" />&nbsp;</td>
     	<td class="inquire_item6"><font color="red">*</font>奖励状态：</td>
      	<td class="inquire_form6">
      		<select id="reward_type" name="reward_type" class="select_width">
				<option value="" >请选择</option>
				<option value="已奖励" >已奖励</option>
				<option value="未奖励" >未奖励</option>
		</select>
      	</td>
    	<td class="inquire_item6"><font color="red">*</font>奖励金额：</td>
      	<td class="inquire_form6"><input type="text" id="reward_money" name="reward_money" class="input_width"  />
      	</td>
    </tr>
    <tr>
     	<td class="inquire_item6">奖励级别：</td>
      	<td class="inquire_form6">
      	<input type="text" id="reward_level" name="reward_level" class="input_width" />
      	</td>
     	<td class="inquire_item6"></td>
     	<td class="inquire_item6"></td>
     	<td class="inquire_item6"></td>
     	<td class="inquire_item6"></td>
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
		debugger;
		var reward_type=document.getElementById("reward_type").value;
		var reward_date=document.getElementById("reward_date").value;
		var reward_money=document.getElementById("reward_money").value;
		if(reward_date==""){
			alert("奖励日期不能为空，请填写！");
			return true;
		}
		if(reward_type==""){
			alert("奖励状态不能为空，请填写！");
			return true;
		}
		if(reward_money==""){
			alert("奖励金额不能为空，请填写！");
			return true;
		}
		return false;
	}
</script>
</html>
<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%
	String contextPath = request.getContextPath();
	String dev_acc_id = request.getParameter("dev_acc_id");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" /> 
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open1.js"></script>
<title>ȷ������ʱ��</title>
</head>
<body class="bgColor_f3f3f3" >
<form name="form1" id="form1" method="post" action="">
<input type="hidden" id="detail_count" value="" />
<div id="new_table_box" style="height:200px">
  <div id="new_table_box_content" style="height:180px">
    <div id="new_table_box_bg" style="height:120px">
      <table id="table1" width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
         <tr>
          <td class="inquire_item4">����ʱ��:</td>
          <td class="inquire_form4">
          	<input id="restart_date" name="restart_date" type="text" size="12"/><img src="<%=contextPath%>/images/calendar.gif" id="tributton2" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(restart_date,tributton2);" />
          </td>
        </tr>
      </table>
    </div>
    <div id="oper_div">
     	<span class="tj_btn"><a href="#" onclick="submitInfo()"></a></span>
        <span class="gb_btn"><a href="#" onclick="newClose()"></a></span>
    </div>
  </div>
</div>
</form>
</body>
<script type="text/javascript"> 
	function submitInfo(){
		var restart_date = $("#restart_date").val();;
		var dev_acc_id = '<%=dev_acc_id%>';
    	var ctt = parent.frames['list'].frames;
		newClose();
		ctt.confirmDateInfo(dev_acc_id,restart_date);
	}
</script>
</html>


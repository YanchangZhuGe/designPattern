<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.cfg.BeanFactory"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@ page import="java.util.*"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String org_id = user.getOrgSubjectionId();
	String user_id = user.getUserId();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" /> 
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script language="javaScript">
	function submit(){
		var ctt = top.frames('list');
		debugger;
		var model_name = document.getElementById("model_name").value;
		var user_name = document.getElementById("user_name").value;
		var create_date = document.getElementById("create_date").value;  

		var sql = "select m.hse_model_id,m.model_name,m.creator_id,u.user_name,m.create_date from bgp_hse_assess_model m join p_auth_user u on m.creator_id=u.user_id and u.bsflag='0' where m.bsflag='0'  and m.creator_id='<%=user_id %>'  ";
		if(model_name!=''&&model_name!=null){
			sql = sql+" and m.model_name like '%"+model_name+"%'";
		}
		if(user_name!=''&&user_name!=null){
			sql = sql+" and u.user_name like '%"+user_name+"%'";
		}
		if(create_date!=''&&create_date!=null){
			sql = sql+" and to_char(m.create_date,'yyyy-MM-dd')='"+create_date+"'";
		}
		sql = sql+"  order by m.modifi_date desc";
		
		ctt.refreshData2(sql);
		newClose();
	}
	
	
</script>
<title>无标题文档</title>
</head>
<body class="bgColor_f3f3f3">
<div id="new_table_box">
  <div id="new_table_box_content">
    <div id="new_table_box_bg">
      <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
        <tr>
        	<td class="inquire_item6">模板名称：</td>
			<td class="inquire_form6"><input type="text" id="model_name" name="model_name" value="" class="input_width"></input></td>
        	<td class="inquire_item6">创建人：</td>
			<td class="inquire_form6"><input type="text" id="user_name" name="user_name" value="" class="input_width"></input></td>
			<td class="inquire_item6">日期：</td>
			<td class="inquire_form6"><input type="text" id="create_date" name="create_date" class="input_width" readonly="readonly"/>
			&nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton1" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(create_date,tributton1);" />&nbsp;
			</td>
		</tr>
      </table>
     
    </div>
    <div id="oper_div">
     	<span class="tj_btn"><a href="#" onclick="submit()"></a></span>
        <span class="gb_btn"><a href="#" onclick="newClose()"></a></span>
    </div>
  </div>
</div>
</body>

</html>


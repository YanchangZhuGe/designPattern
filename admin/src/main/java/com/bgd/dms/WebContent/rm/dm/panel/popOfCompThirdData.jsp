<%@ page contentType="text/html;charset=UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%@ taglib uri="code" prefix="code"%> 
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String devname = request.getParameter("devname");
	String zsnum=request.getParameter("zsnum");
	String code = request.getParameter("code");
	String usageorgid=request.getParameter("usageorgid");
	
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" /> 
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open1.js"></script>

  <title>三级弹出</title> 
 </head>
<body style="background:#fff" onload="loadDataDetail()">
<form name="form1" id="form1" method="post" action="">
<div id="new_table_box" style="width:98%">
  <div id="new_table_box_content" style="width: 100%">
    <div id="new_table_box_bg" style="width: 95%">
     
		&nbsp;设备类别：<%=devname%>&nbsp;&nbsp;总数：<%=zsnum%>&nbsp;
						
      <fieldset><legend>在用</legend>
	  <table id="zyMap" width="50%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
		   <tr>  
			  	  <td class="bt_info_odd">单位</td>
				  <td class="bt_info_even">数量</td>
				  
			  </tr>
			  <tbody id="assign_body"></tbody>
			
	  </table>
	  
	  </fieldset>
	  
	
	  <fieldset><legend>闲置</legend>
	  	<div style="overflow:auto">
	  	<table id="xzMap" width="50%" border="0" cellspacing="0" cellpadding="0" class="tab_info" style="margin-top:2px;">
			  <tr>  
			  	  <td class="bt_info_odd">单位</td>
				  <td class="bt_info_even">数量</td>
			  </tr>
			  <tbody id="assign_body"></tbody>
		  </table>
		 </div>
	</fieldset>
	
	</div>
	  	
			  <div id="oper_div" style="margin-bottom:5px">
			    <span class="gb_btn"><a href="#" onclick="newClose()"></a></span>
			  </div>
		
  </div>
	   
</div>
</form>
</body>
<script type="text/javascript"> 
cruConfig.contextPath='<%=contextPath%>';
	
	function showNewInfo(){
		$("#device_mix_id").val("");
		$("#in_org_name").val($("#in_org_name_info").val());
		$("#in_org_id").val($("#in_org_id_info").val());
		$("#modify_table").show();
	}
	
	
	
	
	function loadDataDetail(){
		var code='<%=code%>';
		var usingdatas = jcdpCallService("DevCommInfoSrv", "getPopThirdData","code="+code);
		
		var zy_body = $("#assign_body","#zyMap")[0];
		if(usingdatas.zyMap != null){
			for (var i = 0; i< usingdatas.zyMap.length; i++) {
				var newTr = zy_body.insertRow();
				newTr.id = usingdatas.zyMap[i].usage_sub_id;
				newTr.insertCell().innerText = usingdatas.zyMap[i].org_name;
				newTr.insertCell().innerText = usingdatas.zyMap[i].zy;
			}
		}
		
		
		
		var xz_body = $("#assign_body","#xzMap")[0];
		if(usingdatas.xzMap != null){
			for (var i = 0; i< usingdatas.xzMap.length; i++) {
				var newTr = xz_body.insertRow();
				newTr.id = usingdatas.xzMap[i].usage_sub_id;
				newTr.insertCell().innerText = usingdatas.xzMap[i].org_name;
				newTr.insertCell().innerText = usingdatas.xzMap[i].xz;
			}
		}
		
		if(usingdatas.dzzyMap != null){
			for (var i = 0; i< usingdatas.dzzyMap.length; i++) {
				var newTr = zy_body.insertRow();
				newTr.id = usingdatas.dzzyMap[i].usage_sub_id;
				newTr.insertCell().innerText = usingdatas.dzzyMap[i].org_name;
				newTr.insertCell().innerText = usingdatas.dzzyMap[i].zy;
			}
		}
		
		if(usingdatas.dzxzMap != null){
			for (var i = 0; i< usingdatas.dzxzMap.length; i++) {
				var newTr = xz_body.insertRow();
				newTr.id = usingdatas.dzxzMap[i].usage_sub_id;
				newTr.insertCell().innerText = usingdatas.dzxzMap[i].org_name;
				newTr.insertCell().innerText = usingdatas.dzxzMap[i].xz;
			}
		}
		
		$("#assign_body>tr:odd>td:odd",'#zyMap').addClass("odd_odd");
		$("#assign_body>tr:odd>td:even",'#zyMap').addClass("odd_even");
		$("#assign_body>tr:even>td:odd",'#zyMap').addClass("even_odd");
		$("#assign_body>tr:even>td:even",'#zyMap').addClass("even_even");
		$("#assign_body>tr:odd>td:odd",'#xzMap').addClass("odd_odd");
		$("#assign_body>tr:odd>td:even",'#xzMap').addClass("odd_even");
		$("#assign_body>tr:even>td:odd",'#xzMap').addClass("even_odd");
		$("#assign_body>tr:even>td:even",'#xzMap').addClass("even_even");
	}
	
	
	
</script>
</html>
 
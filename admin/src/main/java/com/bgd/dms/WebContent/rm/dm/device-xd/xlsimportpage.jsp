<%@ page contentType="text/html;charset=UTF-8"%>
<%@taglib prefix="gms" uri="/WEB-INF/tld/ep.tld"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="java.util.List"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Map"%>
<%@page import="java.net.URLEncoder"%> 
<%@page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@page import="com.cnpc.jcdp.soa.msg.MsgElement"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String method = request.getParameter("method")==null?"":request.getParameter("method");
	String dev_acc_id = request.getParameter("ids");
	String showname = "系统错误，未设置文件类型!";
	if("kq".equals(method)){
		showname = "设备考勤";
	}else if("ys".equals(method)){
		showname = "油水记录";
	}else if("yz".equals(method)){
		showname = "运转记录";
	}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" /> 
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_search.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/json2.js"></script>
<script type="text/javascript" src="<%=contextPath %>/js/external/jquery.bgiframe-2.1.2.js"></script>
<script type="text/javascript" src="<%=contextPath %>/js/ui/jquery.ui.core.js"></script>
<script type="text/javascript" src="<%=contextPath %>/js/ui/jquery.ui.widget.js"></script>
<script type="text/javascript" src="<%=contextPath %>/js/ui/jquery.ui.mouse.js"></script>
<script type="text/javascript" src="<%=contextPath %>/js/ui/jquery.ui.draggable.js"></script>
<script type="text/javascript" src="<%=contextPath %>/js/ui/jquery.ui.position.js"></script>
<script type="text/javascript" src="<%=contextPath %>/js/ui/jquery.ui.resizable.js"></script>
<script type="text/javascript" src="<%=contextPath %>/js/ui/jquery.ui.dialog.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open1.js"></script>
  <title>现场管理导入界面</title> 
</head>
<body style="background:#cdddef" >
<form name="form1" id="form1" method="post"
	action="" enctype="multipart/form-data">
<div id="new_table_box" style="width:750px">
  <div id="new_table_box_content">
    <div id="new_table_box_bg" style="height:60px">
      <fieldset><legend>现场管理数据导入&lt;<%=showname%>&gt;</legend></fieldset>
	  <table width="97%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
		  <tr>					    
			<td class="inquire_item6">文件路径</td>
			<td class="inquire_form6">
				<input type="file" name="doc_excel" />
			</td>
		  </tr>
		</table>
	</div>
	<div id="oper_div">
		<span class="tj_btn"><a href="#" onclick="save()"></a></span>
		<span class="gb_btn"><a href="#" onclick="newClose()"></a></span></div>
	</div>
  </div>
  <div id="dialog-modal" title="正在执行..." style="display:none;">请不要关闭...</div>
</form>
</body>
<script type="text/javascript"> 
	var method = '<%=method%>';
	function save(){
		if(method==""){
			alert("导入功能配置错误，未设置导入的功能类型!");
			return;
		}		
		openMask();
		if(confirm("确认提交？")){
			document.getElementById("form1").action="<%=contextPath%>/rm/dm/saveDMExcel.srq?method=<%=method%>&dev_acc_id=<%=dev_acc_id%>";
			document.getElementById("form1").submit();
		}			
	}
	function openMask(){
		$( "#dialog-modal" ).dialog({
			height: 140,
			modal: true,
			draggable: false
		});
	}
</script>
</html>
 
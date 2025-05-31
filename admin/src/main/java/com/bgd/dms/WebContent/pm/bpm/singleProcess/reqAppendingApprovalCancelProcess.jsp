<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="code" prefix="code"%>
<%@page import="com.bgp.gms.service.op.util.OPCommonUtil"%>
<%@page import="java.util.*"%>
<%@page import="com.bgp.mcs.web.common.util.Base64" %>

<%
	String contextPath = request.getContextPath();
	String extPath = contextPath + "/js/ext-min";
	String _p_p = "";
	Object o = null;
	Object menu_flg = request.getSession().getAttribute("menu_flg");
	if(menu_flg!=null && ((String)menu_flg).equals("2")){
		o = request.getSession().getAttribute("pss_param_map");
		if(o!=null){
			_p_p = (String)o;
			request.getSession().removeAttribute("pss_param_map");
		}
	}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels4.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<style type="text/css">
body {
	font: normal 12px auto "Trebuchet MS", Verdana, Arial, Helvetica,
		sans-serif;
	color: #4f6b72;
	background: #C0E2FB;
	padding: 8px;
}

a {
	color: #c75f3e;
}

#mytable {
	width: 100%;
	padding: 0;
	margin: 0;
}

caption {
	padding: 0 0 5px 0;
	width: 100%;
	font: italic 12px "Trebuchet MS", Verdana, Arial, Helvetica, sans-serif;
	text-align: right;
}	

th {
	font: bold 12px "Trebuchet MS", Verdana, Arial, Helvetica, sans-serif;
	color: black;
	border-right: 1px solid #C1DAD7;
	border-bottom: 1px solid #C1DAD7;
	border-top: 1px solid #C1DAD7;
	letter-spacing: 2px;
	text-transform: uppercase;
	text-align: left;
	padding: 6px 6px 6px 12px;
	background: #5B99DE;
}

td {
	border-right: 1px solid #C1DAD7;
	border-bottom: 1px solid #C1DAD7;
	background: #fff;
	font-size: 12px;
	text-align:center;
	padding: 6px 6px 6px 12px;
	color: black;
}
</style> 

<script language="javaScript">
/**监测系统传递页面参数修改代码 开始**/
	$(function(){
		var _u = "<%=contextPath%>/ei/sap/device/appendingApprovalCancelForPlan.srq";
		var p_param = '';
		<%
		if(!("".equals(_p_p))){
		%>
		p_param = eval('(<%=_p_p%>)');
		<%
		}
		%>
		var _up = "";
		if(!!p_param){
			for(var key in p_param){
				_up = _up + "&" + key + "_88=" + p_param[key];
			}
			p_param='';
			_u = _u + _up;
		}
		$("#wfPic").attr("src",_u);
/**监测系统传递页面参数修改代码 结束**/
		getTab3(0);

		var h = $(window).height();
		$("#tab_box").children().css("height", h-29);
	})
	var selectedTagIndex=0;
	function getTab3(index) {  
		selectedTagIndex = index;
		$("li[id='"+"tag3_"+selectedTagIndex+"']").addClass("selectTag");
		$("li[id!='"+"tag3_"+selectedTagIndex+"']").removeClass();
		$("div[id='"+"tab_box_content"+selectedTagIndex+"']").css("display","block");
		$("div[id!='"+"tab_box_content"+selectedTagIndex+"'][class='tab_box_content']").css("display","none");
		//延迟加载已审批的流程
		if(index==1){
			$("#wfOldPic").attr("src","<%=contextPath%>/bpm/common/toProcessDashbordList.srq?isDone=1")
		}
	}
	
</script>
<title>无标题文档</title>
</head>
<body style="overflow-y:hidden;overflow-x:hidden;padding-left: 0px; padding-right: 0px; padding-top: 0px; padding-bottom: 0px;" >
				<div id="tag-container_3" style="margin-top:2px;margin-left:2px;">
					<ul id="tags" class="tags">
						<li class="selectTag" id="tag3_0"><a id="0" href="#" onclick="getTab3(0)">待办事宜</a>
						</li>
						<li id="tag3_1"><a id="0" href="#" onclick="getTab3(1)">我的流程</a>
						</li>
						<li id="tag3_2"><a id="0" href="#" onclick="getTab3(2)">任务</a>
						</li>
						<li id="tag3_3"><a id="0" href="#" onclick="getTab3(3)">提醒</a>
						</li>
						<li id="tag3_4"><a id="0" href="#" onclick="getTab3(4)">我的问题</a>
						</li>
					</ul>
				</div>
				<div id="tab_box" class="tab_box" style="overflow-y:hidden">
					<div id="tab_box_content0" class="tab_box_content" style="overflow-y:hidden">
						<iframe width="100%" height="100%" name="wfPic" id="wfPic" frameborder="0"  marginheight="0" marginwidth="0"  scrolling="auto"></iframe>
					</div>
					<div id="tab_box_content1" class="tab_box_content"  style="display:none;overflow-y:hidden">
						<iframe width="100%" height="100%" name="wfPic" id="wfOldPic" frameborder="0" src="" marginheight="0" marginwidth="0"  scrolling="auto"></iframe>
					</div>
					<div id="tab_box_content2" class="tab_box_content"  style="display:none;overflow-y:hidden">
					</div>
					<div id="tab_box_content3" class="tab_box_content"  style="display:none;overflow-y:hidden">
						<iframe width="100%" height="100%" name="risk_remind" id="risk_remind" frameborder="0" src="<%=contextPath%>/risk/multiproject/risk_remind_list.jsp" marginheight="0" marginwidth="0"  scrolling="auto"></iframe>
					</div>
					<div id="tab_box_content4" class="tab_box_content"  style="display:none;overflow-y:hidden">
						<iframe width="100%" height="100%" name="risk_remind" id="risk_remind" frameborder="0" src="<%=contextPath%>/risk_remind_list.jsp" marginheight="0" marginwidth="0"  scrolling="auto"></iframe>
					</div>
				</div>

</body>
</html>


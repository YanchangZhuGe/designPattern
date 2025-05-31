<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();
  	//申请id
  	String applyId = request.getParameter("applyId");
  	//申请年度
  	String applyYear = request.getParameter("applyYear");
  //申请年度
  	String plan_type = request.getParameter("plan_type");
%>


<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<title>编辑页面</title>
</head>

<body style="background:#fff" scroll="no">
	<div id="list_table">
		<div id="tag-container_3">
			<ul id="tags" class="tags">
		    	<li class="selectTag" id="tag3_0"><a style="width: 105px;" href="#" onclick="getTab(0)">需求报表</a></li>
		    	<li id="tag3_1"><a style="width: 105px;" href="#" onclick="getTab(1)">辅助资料</a></li>
		  	</ul>
		</div>
		<div id="inq_tool_box">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
					<td background="<%=contextPath%>/images/list_15.png">
						<table width="100%" border="0" cellspacing="0" cellpadding="0">
							<tr>
								<td>&nbsp;</td>
								<auth:ListButton functionId="" css="fh" event="onclick='toBack()'" title="返回"></auth:ListButton>
					  		</tr>
						</table>
					</td>
				   	<td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
				</tr>
			</table>
		</div>
		<div id="tab_box" class="tab_box">
			<div id="tab_box_content0" class="tab_box_content">
				<iframe width="100%" height="99%" name="list" id="iframe_list_0" frameborder="0" src="" marginheight="0" marginwidth="0" >
				</iframe>
			</div>
			<div id="tab_box_content1" class="tab_box_content">
				<iframe width="100%" height="99%" name="list" id="iframe_list_1" frameborder="0" src="" marginheight="0" marginwidth="0" >
				</iframe>
			</div>
		</div>
	</div>
</body>

<script type="text/javascript">
	
	//点击tab页
	var selectedTagIndex = 0;
	var showTabBox = document.getElementById("tab_box_content0");
	var tab_index =0;//tab页索引
	function getTab(index){
		tab_index=index;
		getTab3(index);
		$(".tab_box_content").hide();
		$("#tab_box_content"+index).show();
		if(index==0){
			$("#iframe_list_0").attr("src","<%=contextPath%>/dmsManager/plan/exePlan/require_report_view.jsp?applyId=<%=applyId%>&applyYear=<%=applyYear%>");
		}else if(index==1){
			$("#iframe_list_1").attr("src","<%=contextPath%>/dmsManager/plan/exePlan/supp_data_view.jsp?applyId=<%=applyId%>&applyYear=<%=applyYear%>");
		}
	}
	function frameSize(){
		$("#tab_box .tab_box_content").css("height",$(window).height()-$("#tag-container_3").height()-$("#inq_tool_box").height());
	}
	$(function(){
		frameSize();
		$(window).resize(function(){
	  		frameSize();
		});
		getTab(0);
	});
	function toBack(){
		location.href='<%=contextPath %>/dmsManager/plan/exePlan/apply_list.jsp?plan_type=<%=plan_type%>';
	}
</script>

</html>


<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();
  	//申请id
  	String applyId = request.getParameter("applyId");
  	//申请年度
  	String applyYear = request.getParameter("applyYear");
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
<title>辅助资料</title>
</head>

<body style="background:#fff" scroll="no">
	<div id="list_table">
		<div id="tag-container_3">
		  	<span>&nbsp;&nbsp;</span>
		  	<a style="width: 105px;" href="#" onclick="getTab(0)"><span id="div_a_span0" style="color:#F00;font-size:16px;">市场及分布</span></a>
		  	<span>&nbsp;&nbsp;</span>
		  	<a style="width: 105px;" href="#" onclick="getTab(1)"><span id="div_a_span1" style="font-size:16px;">设备现状分析</span></a>
		  	<span>&nbsp;&nbsp;</span>
		  	<a style="width: 105px;" href="#" onclick="getTab(2)"><span id="div_a_span2" style="font-size:16px;">项目投资效益评价</span></a>
		  	<span>&nbsp;&nbsp;</span>
		  	<a style="width: 105px;" href="#" onclick="getTab(3)"><span id="div_a_span3" style="font-size:16px;">其他说明</span></a>
		</div>
		<div id="tab_box" class="tab_box">
			<div id="tab_box_content0" class="tab_box_content">
				<iframe width="100%" height="100%" name="list" id="iframe_list_0" frameborder="0" src="" marginheight="0" marginwidth="0" >
				</iframe>
			</div>
			<div id="tab_box_content1" class="tab_box_content">
				<iframe width="100%" height="100%" name="list" id="iframe_list_1" frameborder="0" src="" marginheight="0" marginwidth="0" >
				</iframe>
			</div>
			<div id="tab_box_content2" class="tab_box_content">
				<iframe width="100%" height="100%" name="list" id="iframe_list_2" frameborder="0" src="" marginheight="0" marginwidth="0" >
				</iframe>
			</div>
			<div id="tab_box_content3" class="tab_box_content">
				<iframe width="100%" height="100%" name="list" id="iframe_list_3" frameborder="0" src="" marginheight="0" marginwidth="0" >
				</iframe>
			</div>
		</div>
	</div>
</body>

<script type="text/javascript">
	function getTab(index){
		$("span[id^='div_a_span']").css({"color":"#000"});//字体默认黑色
		$("#div_a_span"+index).css({"color":"#F00"});//字体变红
		$(".tab_box_content").hide();
		$("#tab_box_content"+index).show();
		if(index==0){
			$("#iframe_list_0").attr("src","<%=contextPath%>/dmsManager/plan/exePlan/supp_data_market_view.jsp?applyId=<%=applyId%>&applyYear=<%=applyYear%>");
		}else if(index==1){
			$("#iframe_list_1").attr("src","<%=contextPath%>/dmsManager/plan/yearPlan/supp_data_deviceanal_approval.jsp?applyId=<%=applyId%>&applyYear=<%=applyYear%>");
		}else if(index==2){
			$("#iframe_list_2").attr("src","<%=contextPath%>/dmsManager/plan/yearPlan/supp_data_file_approval.jsp?applyId=<%=applyId%>&applyYear=<%=applyYear%>");
		}else if(index==3){
			$("#iframe_list_3").attr("src","<%=contextPath%>/dmsManager/plan/yearPlan/supp_data_remark_approval.jsp?applyId=<%=applyId%>&applyYear=<%=applyYear%>");
		}
	}
	function frameSize(){
		$("#tab_box .tab_box_content").css("height",$(window).height()-$("#tag-container_3").height());
	}
	$(function(){
		frameSize();
		$(window).resize(function(){
	  		frameSize();
		});
		getTab(0);
	});

</script>

</html>


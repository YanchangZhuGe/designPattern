<%@ page contentType="text/html;charset=UTF-8"%>
<%
	String contextPath = request.getContextPath();	
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link href="<%=contextPath%>/styles/panelTableStyle.css" rel="stylesheet" type="text/css" />
<script type="text/javascript"  src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/pm/bpm/common/processInfoCommon.js"></script>
<script type="text/javascript" src="<%=contextPath%>/op/js/opCostCommonJs.js"></script>

 <title>提醒</title>
 </head>

 <body style="background:#fff;padding-left: 0px; padding-right: 0px; padding-top: 0px; padding-bottom: 0px; overflow-y : auto; overflow-x:hidden;">
			<div style="height: auto; overflow-x: auto; margin-top:-2px;">
			  <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">
			     <tr class = "odd">
			      <td>序号</td>
			      <td>类型</td>
			      <td>名称</td>
			      <td>重要程度</td>
			      <td>时间</td>
			     </tr>
			     <tr class = "even">
			      <td>1</td>
			      <td>风险</td>
			      <td>组织结构风险</td>
			      <td>中</td>
			      <td>2012-12-09</td>
			     </tr>
			     <tr class = "odd">
			      <td>2</td>
			      <td>风险</td>
			      <td>质量事故</td>
			      <td>高</td>
			      <td>2012-12-07</td>
			     </tr>			     
			  </table>
			</div>
			<div id="fenye_box"  style="display:block">
				<table width="100%" border="0" cellspacing="0" cellpadding="0" id="fenye_box_table">
				  <tr>
				    <td align="right">第1/1页，共0条记录</td>
				    <td width="10">&nbsp;</td>
				    <td width="30"><img src="<%=contextPath%>/images/fenye_01.png" width="20" height="20" /></td>
				    <td width="30"><img src="<%=contextPath%>/images/fenye_02.png" width="20" height="20" /></td>
				    <td width="30"><img src="<%=contextPath%>/images/fenye_03.png" width="20" height="20" /></td>
				    <td width="30"><img src="<%=contextPath%>/images/fenye_04.png" width="20" height="20" /></td>
				    <td width="50">到
				      <label>
				        <input type="text" name="textfield" id="textfield" style="width:20px;" />
				      </label></td>
				    <td align="left"><img src="<%=contextPath%>/images/fenye_go.png" width="22" height="22" /></td>
				  </tr>
				</table>
			</div>
</body>

</html>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@ page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@ page import="com.cnpc.jcdp.soa.msg.MsgElement"%>
<%@ page import="java.util.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%
		String contextPath = request.getContextPath();
%>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<script type="text/javascript">
</script>
<title>市场信息平台</title>
<link href="<%=contextPath%>/images/ma/style.css" rel="stylesheet" type="text/css" />
<style type="text/css">
</style>
</head>
<body>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td width="112"><img src="<%=contextPath%>/images/ma/sc3_01.png" width="112" height="121" /></td>
    <td width="263"><img src="<%=contextPath%>/images/ma/sc3_02.png" width="263" height="121" /></td>
    <td valign="top"><table width="100%" border="0" cellspacing="0" cellpadding="0">
      <tr>
        <td align="right" style="background:url(<%=contextPath%>/images/ma/sc3_03.png) no-repeat; width:625px; height:25px; text-align:right; padding-right:20px;" class="data_ntext"><span class="red" id="time"></span></td>
      </tr>
      <tr>
        <td>
        	<object id="FlashID" classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" width="627" height="96">
        	<param name="movie" value="<%=contextPath%>/images/ma/bg.swf" />
        	<param name="quality" value="high" /><param name="wmode" value="opaque" />
        	<param name="swfversion" value="7.0.70.0" />
        	</object>
       </td>
      </tr>
    </table></td>
    </tr>
</table>
</body>
</html>
<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="auth" uri="auth"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="java.util.*,com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%
	String contextPath = request.getContextPath();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@include file="/common/include/quotesresource.jsp"%>
<title>Insert title here</title>
</head>
<body style="background:#cdddef;overflow-y:scroll">
<dev id="list_table">
<a href="<%=contextPath%>/help/CheckDev/CheckDev-20160816-V1.0.docx">点击下载</a>
<p align="center">设备验收主要功能操作指南 <br>
  <font color="#FF0000">功能概述： <br>
  功能主要针对二级单位需要调配或新增的设备，由二级单位发起调配，通知到需要的单位。<br>
  对验收人，验收的设备进行统计。并且对设备的状态，设备的完整度，以及设备问题进行汇总、解决。且对供货商进行满意度调查。 <br></font>
  1、验收通知： <br>
  1）验收通知-新增通知 <br>
  <img width="554" height="174" src="<%=contextPath%>/images/helpimage/helpcheckimage/001.jpg"> </br>
  2）点击加号添加申请单：此处需要填写验收通知基本信息和通知附件。 <br>
  <img width="554" height="277" src="<%=contextPath%>/images/helpimage/helpcheckimage/002.jpg"> <br>
  3）保存成功后效果图如下： <br>
  <img width="553" height="195" src="<%=contextPath%>/images/helpimage/helpcheckimage/003.jpg"></p>
<p align="center">2、验收准备： <br>
                1）设备验收—新增验收信息+设备列表+验收小组 <br>
                <img width="554" height="293" src="<%=contextPath%>/images/helpimage/helpcheckimage/004.jpg"> <br>
                2）增加验收准备输入合同号和供货商以及设备信息和验收小组 <br>
                <img width="554" height="346" src="<%=contextPath%>/images/helpimage/helpcheckimage/005.jpg"></p>
<p align="center">3）汇总后效果图如下。 <br>
                <img width="554" height="273" src="<%=contextPath%>/images/helpimage/helpcheckimage/006.jpg"> <br>
                3、验收执行 <br>
                1）验收设备执行 <br>
                <img width="553" height="162" src="<%=contextPath%>/images/helpimage/helpcheckimage/007.jpg"> <br>
                2）点击按钮，填写验证信息、填写验证问题信息，更改验收状态 <br>
                <img width="429" height="365" src="<%=contextPath%>/images/helpimage/helpcheckimage/008.jpg"> <br>
                3）其中的问题信息 <br>
                <img width="554" height="94" src="<%=contextPath%>/images/helpimage/helpcheckimage/009.jpg"> <br>
                4）效果图： <br>
                <img width="553" height="249" src="<%=contextPath%>/images/helpimage/helpcheckimage/010.jpg"> <br>
                4、问题跟踪 <br>
                1）问题跟踪显示解决百分比 <br>
                <img width="553" height="189" src="<%=contextPath%>/images/helpimage/helpcheckimage/011.jpg"> <br>
                2）点击按钮，显示问题详情，问题状态 <br>
                <img width="554" height="249" src="<%=contextPath%>/images/helpimage/helpcheckimage/012.jpg"> <br>
                3）修改问题状态和信息 <br>
                <img width="554" height="240" src="<%=contextPath%>/images/helpimage/helpcheckimage/013.jpg"> <br>
                4）效果图： <br>
				<img width="554" height="123" src="<%=contextPath%>/images/helpimage/helpcheckimage/014.jpg"></p>
<p align="left">&nbsp;</p>
</dev>
</body>
</html>
<%@ page contentType="text/html;charset=utf-8" language="java" pageEncoding="GBK"%>
<%
	String contextPath = request.getContextPath();
	String bussId = request.getParameter("bussId");
	if(bussId==null||bussId.equals("")){
		bussId = "";
	}
	//±¨·ÏÀàĞÍ
	String scrapeType = request.getParameter("scrapeType");
	if(scrapeType==null||scrapeType.equals("")){
		scrapeType = "";
	}
	String fileId = request.getParameter("fileId");
	if(fileId==null||fileId.equals("")){
		fileId = "";
	}
	String scrape_apply_id = request.getParameter("scrape_apply_id");
	if(scrape_apply_id==null||scrape_apply_id.equals("")){
		scrape_apply_id = "";
	}
%>
 <frameset cols="200,*"  frameborder="yes" border="0" framespacing="0">
  <frame  src="<%=contextPath %>/dmsManager/scrape/devTree.jsp?bussId=<%=bussId %>&scrapeType=<%=scrapeType %>&fileId=<%=fileId %>&scrape_apply_id=<%=scrape_apply_id %>" name="mainTopframe" frameborder="no" scrolling="auto"  id="mainTopframe" style="border-right: 2px solid #5796DD; cursor: w-resize;"/>
  <frame  name="devList" src="<%=contextPath %>/dmsManager/scrape/devList.jsp?bussId=<%=bussId %>&scrapeType=<%=scrapeType %>&fileId=<%=fileId %>&scrape_apply_id=<%=scrape_apply_id %>" name="menuFrame" frameborder="no" scrolling="auto"  id="menuFrame" style="border-right: 2px solid #5796DD; cursor: w-resize;"/>
 </frameset>
 
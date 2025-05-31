<%@ page contentType="text/html;charset=utf-8" language="java" %>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>


<frameset cols="20%,*" frameborder="yes" border="0" framespacing="0">
  <frame src="equipmentDirecTree.jsp"  name="mainTopframe" frameborder="no" scrolling="auto" id="mainTopframe" style="border-right: 2px solid #5796DD" width="30%"; cursor: w-resize;"/>
  <frame src="equipmentDirec.jsp" name="mainRightframe" frameborder="no" scrolling="auto" id="mainRightframe" style="border-left: 2px solid #5796DD; cursor: w-resize;"/>
</frameset>

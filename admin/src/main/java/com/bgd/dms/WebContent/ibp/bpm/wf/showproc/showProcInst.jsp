<%@ page contentType="text/html;charset=GBK"%>
<%@ page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<html xmlns:v="urn:schemas-microsoft-com:vml">
<HEAD>
<TITLE></TITLE>
<%
String contextPath = request.getContextPath();
	ISrvMsg respMsg = OMSMVCUtil.getResponseMsg(request);
	

String procinstId="";
String procInstView="";

     if(respMsg.getValue("procInstView")!=null){
		 procInstView =respMsg.getValue("procInstView");
	}	
    if(respMsg.getValue("procinstId")!=null){
		 procinstId =respMsg.getValue("procinstId");
	}	
 %>
<link href="<%=contextPath%>/ibp/bpm/wf/showproc/inc/style.css" type=text/css rel=stylesheet>		

<script language=jscript src="<%=contextPath%>/ibp/bpm/wf/showproc/inc/contextMenu/context.js"></script>
<script language=jscript src="<%=contextPath%>/ibp/bpm/wf/showproc/inc/webflow.js"></script>
<script language=jscript src="<%=contextPath%>/ibp/bpm/wf/showproc/inc/function.js"></script>
<SCRIPT LANGUAGE="JScript">
<!--
var procinstId='<%=procinstId%>';

function loadFromXML(){

 var xml='<%=procInstView%>';
var xmlDoc=new ActiveXObject("Microsoft.XMLDOM");
xmlDoc.async="false";
xmlDoc.loadXML(xml);

  var xmlRoot = xmlDoc.documentElement;  

  FlowXML.value = xmlRoot.xml;
  drawTreeView();
}


//-->
</SCRIPT>
<STYLE>
v\:* { Behavior: url(#default#VML) }
</STYLE>
</HEAD>

<BODY onload='loadFromXML()'scroll="auto">
<div id=treeview>
<INPUT TYPE="hidden" name=FlowXML onpropertychange='redrawVML();'>

	<TABLE cellspacing="0" cellpadding="0" class="panel_style">
	<TR>
	<TD colspan=2 width="800" height="500" onclick="cleancontextMenu();if(objFocusedOff()) redrawVML();return false;" oncontextmenu='if(objFocusedOff()) redrawVML();flowContextMenu();return false;' valign=top align=left>
	<v:group ID="FlowVML" style="position:;WIDTH:800px;HEIGHT:500px;" coordsize = "2000,2000">	
	</v:group>
	</TD>
	</TR>			
	</TABLE>


</BODY>
</HTML>


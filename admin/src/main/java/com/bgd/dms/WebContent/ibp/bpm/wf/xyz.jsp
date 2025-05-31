
<%
String path=request.getContextPath();
 %> 


<frameset cols="205,13,*" frameborder="no" border="0" framespacing="0" id=ind_y >
<FRAME src="<%=path%>/common/navbar-pix.jsp" name=leftframe  FRAMEBORDER="no" TOPMARGIN="0" LEFTMARGIN="0" MARGINHEIGHT="0" MARGINWIDTH="0" scrolling="auto"> 
    <FRAME name=meddleframe src="/common/ooo1.html" scrolling=no resize="no">
    <FRAME src="importantList.html" name=mainframe FRAMEBORDER="no"  TOPMARGIN="0" LEFTMARGIN="0" MARGINHEIGHT="0" MARGINWIDTH="0" >
</frameset>
<noframes>
</noframes>

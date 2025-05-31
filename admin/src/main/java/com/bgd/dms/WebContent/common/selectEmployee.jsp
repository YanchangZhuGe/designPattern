<%
	String orgId = request.getParameter("orgId");
	if(orgId==null || orgId.equals("")) {
	request.getRequestDispatcher("selectOrgHR.jsp?select=employeeId").forward(request,response);
	}else{
	request.getRequestDispatcher("selectOrgHR.jsp?select=employeeId&orgId="+orgId).forward(request,response);
	
	}
%>
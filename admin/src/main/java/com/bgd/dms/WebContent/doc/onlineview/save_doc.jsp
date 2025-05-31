<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%

	SOAOfficeX.SaveDocObj   SOAObj  = new SOAOfficeX.SaveDocObj(pageContext);
	String newPath = request.getParameter("newPath");	
	try{
		SOAObj.saveToFile(newPath);  // saveToFile
		SOAObj.returnOK();
	}
	finally 
	{
		SOAObj.close();
	}	
%>
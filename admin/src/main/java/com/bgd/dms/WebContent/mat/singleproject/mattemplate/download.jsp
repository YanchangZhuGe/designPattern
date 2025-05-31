<%@page contentType="text/html" pageEncoding="GBK"%>
<%@ page import="java.io.*"%>

<%
	String path = request.getParameter("path"); 
	String filename = request.getParameter("filename"); 
	int index=path.lastIndexOf("/");
	if(filename==null||filename.length()==0)
		filename=path.substring(index+1);

	try{
	    File f = new File(request.getSession().getServletContext().getRealPath(path));

	    response.setContentType("application/force-download;");
	    response.setHeader("Content-Disposition", "attachment;filename=\"" + new String(filename.getBytes("GBK"),"iso8859-1") + "\"");
	    InputStream in = new FileInputStream(f);
	    BufferedInputStream bis=new BufferedInputStream(in);
	    ServletOutputStream output = response.getOutputStream();
	    int byteLength = 0;
	    byte[] buffer = new byte[8192];
	    while ((byteLength = bis.read(buffer, 0, 8192)) != -1) {
	      	output.write(buffer, 0, byteLength);
	    }
		output.flush();
		output.close();
		bis.close();
		in.close();
		out.clear();
		out = pageContext.pushBody();
	} catch (Exception ex) {
		
	}
%> 
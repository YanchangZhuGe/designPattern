<%@page contentType="text/html;charset=GBK" pageEncoding="GBK"%>
<%@ page import="java.io.*"%>

<%
	String filename = request.getParameter("filename"); 
	String showname = request.getParameter("showname");
	filename=java.net.URLDecoder.decode(filename, "utf-8");
	try{
	    File f = new File(request.getSession().getServletContext().getRealPath("/WEB-INF/temp/dm/"+filename));
	    response.setContentType("application/force-download;");
	    response.setHeader("Content-Disposition", "attachment;filename=\"" + showname + "\"");
	    
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
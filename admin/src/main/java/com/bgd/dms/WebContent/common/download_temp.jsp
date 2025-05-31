<%@page contentType="text/html;charset=GBK" pageEncoding="GBK"%>
<%@ page import="java.io.*,java.net.*"%>

<%
	String filename = request.getParameter("filename"); 

	//filename=java.net.URLDecoder.decode(filename, "utf-8");
	
	String showname = request.getParameter("showname"); 
	
	//showname=java.net.URLDecoder.decode(showname, "utf-8");
	System.out.println("filename===="+filename +"showname======"+showname);

	try{
	    File f = new File(request.getSession().getServletContext().getRealPath("/WEB-INF/temp/"+filename));
	    response.setContentType("application/x-msdownload"); 
	    response.setHeader("Content-Disposition", "attachment;filename="+showname);
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
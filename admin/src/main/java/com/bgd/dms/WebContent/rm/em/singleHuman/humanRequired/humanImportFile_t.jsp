<%@page import="java.text.SimpleDateFormat"%>
<%@ page language="java" contentType="text/html; charset=GBK"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@ page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@ page import="java.util.*"%>
<%@ page import="java.io.*"%> 
<%@ page import="java.io.OutputStream"%> 
<%@ page import="org.apache.poi.xssf.usermodel.XSSFRow"%>
<%@ page import="org.apache.poi.xssf.usermodel.XSSFSheet"%>
<%@ page import="org.apache.poi.xssf.usermodel.XSSFWorkbook"%> 
<%@ page import="org.apache.poi.xssf.usermodel.XSSFCell"%> 
<%@ page import="org.apache.poi.hssf.usermodel.*"%>
<%@ page import="org.apache.poi.ss.usermodel.*"%>

<%@ page import="org.apache.commons.fileupload.FileItem"%>
<%@ page import="org.apache.commons.fileupload.FileItemFactory"%>
<%@ page import="org.apache.commons.fileupload.disk.DiskFileItemFactory"%>
<%@ page import="org.apache.commons.fileupload.servlet.ServletFileUpload"%>
<%@ page import="com.cnpc.jcdp.soa.msg.MsgElement"%> 
<%@page import="com.cnpc.jcdp.common.UserToken"%> 
<%@page import="com.cnpc.jcdp.cfg.BeanFactory"%> 

<%@ taglib uri="code" prefix="code"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();
	int deviceCount = Integer.parseInt(request.getParameter("deviceCount"));
	SimpleDateFormat datetemp=new SimpleDateFormat("yyyy-MM-dd");
	FileItemFactory factory = new DiskFileItemFactory();
	ServletFileUpload upload = new ServletFileUpload(factory);
	List /* FileItem */items = upload.parseRequest(request);
	Iterator iter = items.iterator();
	while (iter.hasNext()) {
		FileItem item = (FileItem) iter.next();
		
		if (!item.isFormField()) {
			String fileName = item.getName();
			System.out.println(fileName);
			System.out.println(item.getContentType());

			String returnValue="";
			String errors="";
			StringBuffer contents = new StringBuffer("");
			try{		
				Workbook book = null;
				Sheet sheet = null;
				Row row = null;
				if ("application/vnd.ms-excel".equals(item.getContentType())) {		
					book = new HSSFWorkbook(item.getInputStream());
					sheet = book.getSheetAt(0);  						
				}else if ("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet".equals(item.getContentType())) {
					book = new XSSFWorkbook(item.getInputStream());
					sheet = book.getSheetAt(0);							
				}
				if(sheet != null ){
					int  sumCount  = sheet.getLastRowNum()-1;
					 
					//System.out.println("deviceCount = " + deviceCount  +"sumCount="+sumCount);
					if(sumCount <= deviceCount){
						for (int i = 2; i <= sheet.getLastRowNum(); i++) {   
							row = sheet.getRow(i);
					
							String team = "";
							String post = "";
							String startDate = "";
							String endDate = "";
							
							String zNum = "";
							String lNum = "";
							
							for (int j = row.getFirstCellNum(); j < row.getLastCellNum(); j++) {
								Cell ss=row.getCell(j);
								if(ss!=null && !"".equals(ss.toString())){
									switch(j){
									case 1:ss.setCellType(1); team = ss.getStringCellValue(); break;
									case 2:ss.setCellType(1); post = ss.getStringCellValue();  break;
									
									case 3:								
										//if(ss.getCellType()==0){
											//ss.setCellType(0); startDate = datetemp.format(ss.getDateCellValue());
										//} 
										ss.setCellType(1); startDate = ss.getStringCellValue(); 
										break;
									case 4:
										//if(ss.getCellType()==0){
										//	ss.setCellType(0); endDate = datetemp.format(ss.getDateCellValue());
										//}
										ss.setCellType(1); endDate = ss.getStringCellValue();
										break;
										
									case 9:ss.setCellType(1); zNum = ss.getStringCellValue(); break;
									case 10:ss.setCellType(1); lNum = ss.getStringCellValue(); break;
									
									default:break;
									}
								}
							}
							if(zNum!=null && !"".equals(zNum) && lNum!=null && !"".equals(lNum)){
								
								contents.append(zNum).append("@").append(lNum).append("@");
								if(team != null && !"".equals(team)){
									contents.append(team).append("@");
								}else{
									contents.append("").append("@");
								}
								if(post != null && !"".equals(post)){
									contents.append(post).append("@");
								}else{
									contents.append("").append("@");
								}
								if(startDate != null && !"".equals(startDate)){
									contents.append(startDate).append("@");
								}else{
									contents.append("").append("@");
								}
								if(endDate != null && !"".equals(endDate)){
									contents.append(endDate).append("@").append(",");
								}else{
									contents.append("").append("@").append(",");
								}
								
							 
									
							}else{
								errors+="第"+(i+1)+"行<本次申请人数> 或 <其中临时季节性人数> 不能为空;\\n";
							}	
							
							
								
						 }  //  第一个for 循环
			   	 }else{
			   		 
			   		errors+="EXCEL条数与页面条数不一致,请重新下载模板进行导入!";
			   	 }
					
				}//...if(sheet != null ) 				
				if (!"".equals(returnValue)) {
					returnValue = returnValue.substring(0, returnValue.length() - 1);
				}
			}catch(Exception e){
				System.out.println(e.getMessage());
				
			}
			returnValue=contents.toString();
			if(returnValue.endsWith(",")){
				returnValue=returnValue.substring(0,returnValue.length()-1);
			}
			if(errors != ""){
				out.write("<script type=\"text/javascript\">parent.alertError('"+ errors+"');parent.content='"+ returnValue + "';window.returnValue='" + returnValue
						+ "';parent.document.getElementById('confirmButton').disabled=false;</script>");
			}else{
				out.write("<script type=\"text/javascript\">parent.content='" + returnValue + "';window.returnValue='" + returnValue
						+ "';parent.document.getElementById('confirmButton').disabled=false;</script>");
			}
			
		}
	}
%>

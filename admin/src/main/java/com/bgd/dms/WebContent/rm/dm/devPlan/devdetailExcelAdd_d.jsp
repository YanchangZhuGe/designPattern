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
<%@ taglib uri="code" prefix="code"%>
<%
	String contextPath = request.getContextPath();
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
				System.out.println(item.getContentType());
				if ("application/octet-stream".equals(item.getContentType())||"application/vnd.ms-excel".equals(item.getContentType())) {
					book = new HSSFWorkbook(item.getInputStream());
					sheet = book.getSheetAt(0);  						
				}else if ("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet".equals(item.getContentType())) {
					book = new XSSFWorkbook(item.getInputStream());
					sheet = book.getSheetAt(0);							
				}
				if(sheet != null ){
					for (int i = 1; i <= sheet.getLastRowNum(); i++) {   
						row = sheet.getRow(i);
 						String devName = "";//设备名称1
						String devType="";//设备型号2
						String devUnit = "";//单位3
						String devNum = "";//数量4
						String startDate = "";//开始日期5
						String endDate = "";//结束日期6
						String purpose = "";//备注
 						for (int j = row.getFirstCellNum(); j < row.getLastCellNum(); j++) {
							Cell ss=row.getCell(j);
							System.out.print(ss);
							if(ss!=null && !"".equals(ss.toString())){
								switch(j){
								case 0:ss.setCellType(1);  devName = ss.getStringCellValue();  System.out.print(devName); break;
								case 1:ss.setCellType(1); devType = ss.getStringCellValue();System.out.print(devType); break;
								case 2:ss.setCellType(1); devUnit = ss.getStringCellValue();System.out.print(devUnit); break;
								case 3:ss.setCellType(1); devNum = ss.getStringCellValue(); System.out.print(devNum);break;
								case 4:ss.setCellType(1); startDate = ss.getStringCellValue(); System.out.print(startDate);break;
								case 5:ss.setCellType(1); endDate = ss.getStringCellValue(); System.out.print(endDate); break;
								case 6:ss.setCellType(1); purpose = ss.getStringCellValue(); System.out.print(purpose); break;
 								default:break;
								}
							}
						}
					 
						if(devName!=null && !"".equals(devName) ){
							contents.append(devName).append("@");
						}else{
							contents.append(" ").append("@");
						}
						if(devType!=null && !"".equals(devType) ){
							contents.append(devType).append("@");
						}else{
							contents.append(" ").append("@");
						}
						if(devUnit!=null && !"".equals(devUnit) ){
							contents.append(devUnit).append("@");
						}else{
							contents.append(" ").append("@");
						}
						if(devNum!=null && !"".equals(devNum) ){
							contents.append(devNum).append("@");
						}else{
							contents.append(" ").append("@");
						}
						if(startDate!=null && !"".equals(startDate) ){
							contents.append(startDate).append("@");
						}else{
							contents.append(" ").append("@");
						}
						if(endDate!=null && !"".equals(endDate) ){
							contents.append(endDate).append("@");
						}else{
							contents.append(" ").append("@");
						}
						if(purpose!=null && !"".equals(purpose) ){
							contents.append(purpose).append(",");
						}else{
							contents.append(" ").append(",");
						}
					 
					}  
				}
				if (!"".equals(returnValue)) {
					returnValue = returnValue.substring(0, returnValue.length() - 1);
				}
			}catch(Exception e){
				System.out.println(e.getMessage());
				
			}
			System.out.println(contents.toString());
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

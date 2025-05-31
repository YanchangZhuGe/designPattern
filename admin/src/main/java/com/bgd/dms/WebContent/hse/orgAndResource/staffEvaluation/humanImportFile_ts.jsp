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
				if ("application/vnd.ms-excel".equals(item.getContentType())) {		
					book = new HSSFWorkbook(item.getInputStream());
					sheet = book.getSheetAt(0);  						
				}else if ("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet".equals(item.getContentType())) {
					book = new XSSFWorkbook(item.getInputStream());
					sheet = book.getSheetAt(0);							
				}
				if(sheet != null ){
					for (int i = 4; i <= sheet.getLastRowNum(); i++) {   
						row = sheet.getRow(i); 						
						String staff_name="";
						String staff_position="";
						String staff_health="";
						String constraindication="";
						String degrees="";
						String work_experience="";	
						String interview="";
						String qualification="";
						String exam="";
						String subversion="";
						String work_ethic="";
						String emergency_power="";
						String competent="";						
						 
						for (int j = row.getFirstCellNum(); j < row.getLastCellNum(); j++) {
							Cell ss=row.getCell(j);
							if(ss!=null && !"".equals(ss.toString())){
								switch(j){
								case 0:ss.setCellType(1); staff_name = ss.getStringCellValue(); break;
								case 1:ss.setCellType(1); staff_position = ss.getStringCellValue();  break;
								case 2:ss.setCellType(1); staff_health = ss.getStringCellValue(); break;
								case 3:ss.setCellType(1); constraindication = ss.getStringCellValue(); break;
								case 4:ss.setCellType(1); degrees = ss.getStringCellValue(); break;
								case 5:ss.setCellType(1); work_experience = ss.getStringCellValue(); break;
								case 6:ss.setCellType(1); interview = ss.getStringCellValue(); break;
								case 7:ss.setCellType(1); qualification = ss.getStringCellValue(); break;
								case 8:ss.setCellType(1); exam = ss.getStringCellValue(); break;
								case 9:ss.setCellType(1); subversion = ss.getStringCellValue(); break;
								case 10:ss.setCellType(1); work_ethic = ss.getStringCellValue(); break;
								case 11:ss.setCellType(1); emergency_power = ss.getStringCellValue(); break;
								case 12:ss.setCellType(1); competent = ss.getStringCellValue(); break;								
								default:break;
								}
							}
						}
						if(staff_name!=null && !"".equals(staff_name) && staff_position!=null && !"".equals(staff_position) && competent!=null && !"".equals(competent)   ){ 
							contents.append(staff_name).append("@");   
							contents.append(staff_position).append("@");   
							
							if(staff_health != null && !"".equals(staff_health)){
								contents.append(staff_health).append("@");
							}else{
								contents.append("").append("@");
							}
							if(constraindication != null && !"".equals(constraindication)){
								contents.append(constraindication).append("@");
							}else{
								contents.append("").append("@");
							}
		 
							if(degrees != null && !"".equals(degrees)){
								contents.append(degrees).append("@");
							}else{
								contents.append("").append("@");
							}
		 
							if(work_experience != null && !"".equals(work_experience)){
								contents.append(work_experience).append("@");
							}else{
								contents.append("").append("@");
							}
		 
							if(interview != null && !"".equals(interview)){
								contents.append(interview).append("@");
							}else{
								contents.append("").append("@");
							}
		 
							if(qualification != null && !"".equals(qualification)){
								contents.append(qualification).append("@");
							}else{
								contents.append("").append("@");
							}
		 
							if(exam != null && !"".equals(exam)){
								contents.append(exam).append("@");
							}else{
								contents.append("").append("@");
							}
		 
							
							if(subversion != null && !"".equals(subversion)){
								contents.append(subversion).append("@");
							}else{
								contents.append("").append("@");
							}
		 
							if(work_ethic != null && !"".equals(work_ethic)){
								contents.append(work_ethic).append("@");
							}else{
								contents.append("").append("@");
							}
		 
							
							if(emergency_power != null && !"".equals(emergency_power)){
								contents.append(emergency_power).append("@");
							}else{
								contents.append("").append("@");
							}
		  
							
							if(competent != null && !"".equals(competent)){
								contents.append(competent).append("@").append(",");
							}else{
								contents.append("").append("@").append(",");
							}
							 
							 
						}else{
							errors+="第"+(i+1)+"行红色标注项不能为空;\\n";
						}	
					}  
				}				
				if (!"".equals(returnValue)) {
					returnValue = returnValue.substring(0, returnValue.length() - 1);
				}
			}catch(Exception e){
				System.out.println(e.getMessage());
				
			}
			returnValue=contents.toString(); 
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

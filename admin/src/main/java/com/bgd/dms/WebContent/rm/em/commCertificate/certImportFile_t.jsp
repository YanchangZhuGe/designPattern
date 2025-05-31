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
					for (int i = 2; i <= sheet.getLastRowNum(); i++) {   
						row = sheet.getRow(i);
						
						String employee_name = "";
						String employee_cd = "";
						String qualification_name ="";
						String certificate_num = "";
						String training_institutions = "";
						String issuing_agency = "";
						String issuing_date = "";
						String validity = "";
						String practice_num = "";
						String practice_date = "";
						String qualification_level = "";

												
						for (int j = row.getFirstCellNum(); j < row.getLastCellNum(); j++) {
							Cell ss=row.getCell(j);
							if(ss!=null && !"".equals(ss.toString())){
								switch(j){
								case 0:ss.setCellType(1); employee_name = ss.getStringCellValue(); break;
								case 1:ss.setCellType(1); employee_cd = ss.getStringCellValue(); break;
								case 2:ss.setCellType(1); qualification_name = ss.getStringCellValue(); break;								
								case 3:ss.setCellType(1); certificate_num = ss.getStringCellValue();  break;
								case 4:ss.setCellType(1); training_institutions = ss.getStringCellValue();  break;
								case 5:ss.setCellType(1); issuing_agency = ss.getStringCellValue();  break;
								case 6:
									if(ss.getCellType()==0){
										ss.setCellType(0); issuing_date = datetemp.format(ss.getDateCellValue());
									}
									break;
								case 7:
									if(ss.getCellType()==0){
										ss.setCellType(0); validity = datetemp.format(ss.getDateCellValue());
									}
									break;
								case 8:ss.setCellType(1); practice_num = ss.getStringCellValue();  break;
								case 9:
									if(ss.getCellType()==0){
										ss.setCellType(0); practice_date = datetemp.format(ss.getDateCellValue());
									}
									break;
								case 10:ss.setCellType(1); qualification_level = ss.getStringCellValue();  break;

								default:break;
								}
							}
						}
						if(employee_name!=null && !"".equals(employee_name) && employee_cd!=null && !"".equals(employee_cd)){
							contents.append(employee_name).append("@").append(employee_cd).append("@");
							contents.append(qualification_name).append("@");
							contents.append(certificate_num).append("@");
							contents.append(training_institutions).append("@");
							contents.append(issuing_agency).append("@");
							contents.append(issuing_date).append("@");
							contents.append(validity).append("@");
							contents.append(practice_num).append("@");
							contents.append(practice_date).append("@");
							contents.append(qualification_level).append(",");

						}else{
							errors+="第"+(i+1)+"行姓名或人员编号为空;\\n";
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

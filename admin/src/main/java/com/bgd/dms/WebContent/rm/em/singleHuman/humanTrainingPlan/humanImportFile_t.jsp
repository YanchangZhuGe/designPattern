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
					for (int i = 3; i <= sheet.getLastRowNum(); i++) {   
						row = sheet.getRow(i); 
						String trainContent = "";
						String classification = "";
						String trainNumber = "";
						String trainClass = "";
						String trainCost = "";
						String trainTransportation = "";
						String trainMaterials = "";
						String trainPlaces = "";
						String trainAccommodation = "";
						String trainOther = "";
			  
						for (int j = row.getFirstCellNum(); j < row.getLastCellNum(); j++) {
							Cell ss=row.getCell(j);
							if(ss!=null && !"".equals(ss.toString())){
								switch(j){
								case 0:ss.setCellType(1); trainContent = ss.getStringCellValue(); break;
								case 1:ss.setCellType(1); classification = ss.getStringCellValue();  break;
								case 2:ss.setCellType(1); trainNumber = ss.getStringCellValue(); break;
								case 3:ss.setCellType(1); trainClass = ss.getStringCellValue(); break;
								case 4:ss.setCellType(1); trainCost = ss.getStringCellValue(); break;			
								case 5:ss.setCellType(1); trainTransportation = ss.getStringCellValue(); break;	 
								case 6:ss.setCellType(1); trainMaterials = ss.getStringCellValue(); break;	
								case 7:ss.setCellType(1); trainPlaces = ss.getStringCellValue(); break;	
								case 8:ss.setCellType(1); trainAccommodation = ss.getStringCellValue(); break;	
								case 9:ss.setCellType(1); trainOther = ss.getStringCellValue(); break;	 
								default:break;
								}
							}
						}
						if(trainContent!=null && !"".equals(trainContent) && classification!=null && !"".equals(classification)){ 
							contents.append(trainContent).append("@");  
							
							if(classification.equals("质量")){
								contents.append("1").append("@");
							}else if(classification.equals("HSE")){
								contents.append("2").append("@");
							}else if(classification.equals("其他")){
								contents.append("3").append("@");
							} else if(classification.equals("HSE和质量")){
								contents.append("4").append("@");
							} else if(classification.equals("操作技能")){
								contents.append("5").append("@");
							} 
							
							
							if(trainNumber != null && !"".equals(trainNumber)){
								contents.append(trainNumber).append("@");
							}else{
								contents.append("").append("@");
							}
							if(trainClass != null && !"".equals(trainClass)){
								contents.append(trainClass).append("@");
							}else{
								contents.append("").append("@");
							}
							if(trainCost != null && !"".equals(trainCost)){
								contents.append(trainCost).append("@");
							}else{
								contents.append("").append("@");
							}
							if(trainTransportation != null && !"".equals(trainTransportation)){
								contents.append(trainTransportation).append("@");
							}else{
								contents.append("").append("@");
							}
							if(trainMaterials != null && !"".equals(trainMaterials)){
								contents.append(trainMaterials).append("@");
							}else{
								contents.append("").append("@");
							}
							if(trainPlaces != null && !"".equals(trainPlaces)){
								contents.append(trainPlaces).append("@");
							}else{
								contents.append("").append("@");
							}
							if(trainAccommodation != null && !"".equals(trainAccommodation)){
								contents.append(trainAccommodation).append("@");
							}else{
								contents.append("").append("@");
							}
							
							if(trainOther != null && !"".equals(trainOther)){
								contents.append(trainOther).append("@").append(",");
							}else{
								contents.append("").append("@").append(",");
							}
							
							 
						}else{
							errors+="第"+(i+1)+"行内容或分类编号为空;\\n";
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

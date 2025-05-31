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
						String team = "";
						String post = "";
						String peopleNumber = "";
						String professNumber = "";
						String planStartDate = "";
						String planStartDate_sb = "";
						String planEndDate = "";
						String planEndDate_sb = "";
						for (int j = row.getFirstCellNum(); j < row.getLastCellNum(); j++) {
							Cell ss=row.getCell(j);
							if(ss!=null && !"".equals(ss.toString())){
								switch(j){
								case 0:ss.setCellType(1); team = ss.getStringCellValue(); break;
								case 1:ss.setCellType(1); post = ss.getStringCellValue();  break;
								case 2:ss.setCellType(1); peopleNumber = ss.getStringCellValue(); break;
								case 3:ss.setCellType(1); professNumber = ss.getStringCellValue(); break;
								case 4:								
									//if(ss.getCellType()==0){
										//ss.setCellType(0); planStartDate = datetemp.format(ss.getDateCellValue());
									}  
								if(ss.getCellType()==0){
									planStartDate_sb=new SimpleDateFormat("yyyy-MM-dd").format(ss.getDateCellValue());
								}else{
									ss.setCellType(1);
									planStartDate_sb = ss.getStringCellValue().trim(); // 对应赋值
								}
								//boolean a = planStartDate_sb.contains("-");	errors+="第"+(i+1)+a;
								planStartDate_sb=planStartDate_sb.replace("/", "-");
								String[] biths=planStartDate_sb.split("-");
								String temp="";
 								for(int r=0;r<biths.length;r++){
 									if(biths[r].length()==1){
 									biths[r]="0"+biths[r];
 									}
 									if(r==biths.length-1){
 										temp+=biths[r];
 									}else{
 										temp+=biths[r]+"-";
 									}
 									
 								}
 						
 								planStartDate=temp;
 								try{
 									new SimpleDateFormat("yyyy-MM-dd").parse(planStartDate);
 								}catch(Exception e){
 							 
 									errors+="第"+(i+1)+"行计划进入时间日期格式不正确;\\n";
 									 
 								}
 								
									break;
								case 5:
									//if(ss.getCellType()==0){
										//ss.setCellType(0); planEndDate = datetemp.format(ss.getDateCellValue());
									//}
									
									if(ss.getCellType()==0){
										planEndDate_sb=new SimpleDateFormat("yyyy-MM-dd").format(ss.getDateCellValue());
									}else{
										ss.setCellType(1);
										planEndDate_sb = ss.getStringCellValue().trim(); // 对应赋值
									}
									//boolean b = planEndDate_sb.contains("-");	errors+="第"+(i+1)+b;
									planEndDate_sb=planEndDate_sb.replace("/", "-");
									String[] biths_B=planEndDate_sb.split("-");
									String temp_B="";
	 								for(int r=0;r<biths_B.length;r++){
	 									if(biths_B[r].length()==1){
	 										biths_B[r]="0"+biths_B[r];
	 									}
	 									if(r==biths_B.length-1){
	 										temp_B+=biths_B[r];
	 									}else{
	 										temp_B+=biths_B[r]+"-";
	 									}
	 									
	 								}
	 					
	 								planEndDate=temp_B;
	 								try{
	 									new SimpleDateFormat("yyyy-MM-dd").parse(planEndDate);
	 								}catch(Exception e){
	 							 
	 									errors+="第"+(i+1)+"行计划离开时间日期格式不正确;\\n";
	 									 
	 								}
	 								
									break;
								default:break;
								}
							}
						}
						
						if(team != null && !"".equals(team)){
							contents.append(team).append("@");
						}else{
							errors+="第"+(i+1)+"行班组不能为空;\\n";
						}
						if(post != null && !"".equals(post)){
							contents.append(post).append("@");
						}else{
							errors+="第"+(i+1)+"行岗位不能为空;\\n";
						}
						if(peopleNumber != null && !"".equals(peopleNumber)){
							contents.append(peopleNumber).append("@");
						}else{
							errors+="第"+(i+1)+"行计划人数不能为空;\\n";
						}
						if(professNumber != null && !"".equals(professNumber)){
							contents.append(professNumber).append("@");
						}else{
							errors+="第"+(i+1)+"行计划人数不能为空;\\n";
						}
						if(planStartDate != null && !"".equals(planStartDate)){
							contents.append(planStartDate).append("@");
						}else{
							errors+="第"+(i+1)+"行计划进入时间不能为空;\\n";
						}
						if(planEndDate != null && !"".equals(planEndDate)){
							contents.append(planEndDate).append("@").append(",");
						}else{
							errors+="第"+(i+1)+"行计划离开时间不能为空;\\n";
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

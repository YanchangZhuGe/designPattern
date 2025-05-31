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
				if ("application/octet-stream".equals(item.getContentType())||"application/vnd.ms-excel".equals(item.getContentType())) {		
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
						String planEndDate = "";
						for (int j = row.getFirstCellNum(); j < row.getLastCellNum(); j++) {
							Cell ss=row.getCell(j);
							if(ss!=null && !"".equals(ss.toString())){
								switch(j){
								case 0:ss.setCellType(1); team = ss.getStringCellValue(); break;
								case 1:ss.setCellType(1); post = ss.getStringCellValue();  break;
								case 2:ss.setCellType(1); peopleNumber = ss.getStringCellValue(); break;
								//case 3:ss.setCellType(1); professNumber = ss.getStringCellValue(); break;
								case 3:								
									if(ss.getCellType()==0){
										ss.setCellType(0); planStartDate = datetemp.format(ss.getDateCellValue());
									}  
									break;
								case 4:
									if(ss.getCellType()==0){
										ss.setCellType(0); planEndDate = datetemp.format(ss.getDateCellValue());
									}
									break;
								default:break;
								}
							}
						}
						
						if(team != null && !"".equals(team)){
							contents.append(team).append("@");
						}else{
							errors+="��"+(i+1)+"�а��鲻��Ϊ��;\\n";
						}
						if(post != null && !"".equals(post)){
							contents.append(post).append("@");
						}else{
							errors+="��"+(i+1)+"�и�λ����Ϊ��;\\n";
						}
						if(peopleNumber != null && !"".equals(peopleNumber)){
							contents.append(peopleNumber).append("@");
						}else{
							errors+="��"+(i+1)+"�мƻ���������Ϊ��;\\n";
						}
						/**if(professNumber != null && !"".equals(professNumber)){
							contents.append(professNumber).append("@");
						}else{
							errors+="��"+(i+1)+"�мƻ���������Ϊ��;\\n";
						}
						if(planStartDate != null && !"".equals(planStartDate)){
							contents.append(planStartDate).append("@");
						}else{
							errors+="��"+(i+1)+"�мƻ�����ʱ�䲻��Ϊ��;\\n";
						}
						if(planEndDate != null && !"".equals(planEndDate)){
							contents.append(planEndDate).append("@").append(",");
						}else{
							errors+="��"+(i+1)+"�мƻ��뿪ʱ�䲻��Ϊ��;\\n";
						}*/
						contents.append(planStartDate).append("@");
						contents.append(planEndDate).append("@").append(",");
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

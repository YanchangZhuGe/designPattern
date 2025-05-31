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
		System.out.println("*************************************************************");
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
					for (int i = 1; i <= sheet.getLastRowNum(); i++) {   
						row = sheet.getRow(i);
						String wzId = "";
						String wzName = "";
						String wzPriceic = "";
						String wzPrice = "";
						String unit_num = "";
						String demand_num = "";
						String demand_date = "";
						String note = "";
						for (int j = row.getFirstCellNum(); j < row.getLastCellNum(); j++) {
							Cell ss=row.getCell(j);
							if(ss!=null && !"".equals(ss.toString())){
								switch(j){
								case 0:ss.setCellType(1); wzId = ss.getStringCellValue(); break;
								case 3:ss.setCellType(1); wzPrice = ss.getStringCellValue();  break;
								case 4:ss.setCellType(1); demand_num = ss.getStringCellValue();  break;
								case 6:ss.setCellType(1); demand_date = ss.getStringCellValue();  break;
								case 7:ss.setCellType(1); note = ss.getStringCellValue();  break;
								default:break;
								}
							}
						}
						if(wzId!=null && !"".equals(wzId) ){
							String hisDatas = contents.toString();
							if(hisDatas.indexOf(wzId)!=-1){
								errors+="第"+(i+1)+"行物资编码重复，请修改;\\n";
							}
							contents.append(wzId).append("@");
							if(demand_num != null && !"".equals(demand_num)){
								contents.append(demand_num).append("@");
							}else{
								contents.append(" ").append("@");
							}
							if(demand_date != null && !"".equals(demand_date)){
								contents.append(demand_date).append("@");
							}else{
								contents.append(" ").append("@");
							}
							if(wzPrice!=null && !"".equals(wzPrice)){
								contents.append(wzPrice).append("@");
							}else{
								contents.append(" ").append("@");
							}
							if(note != null && !"".equals(note)){
								contents.append(note).append(",");
							}else{
								contents.append(" ").append(",");
							}
						}else{
							errors+="第"+(i+1)+"行物资编码为空;\\n";
						}
						System.out.println(contents);
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

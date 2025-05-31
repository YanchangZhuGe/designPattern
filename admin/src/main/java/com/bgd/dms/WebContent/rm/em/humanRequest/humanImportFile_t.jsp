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
						String name = "";
						String id = "";
						String team = "";
						String post = "";
						String startDate = "";
						String endDate = "";
						for (int j = row.getFirstCellNum(); j < row.getLastCellNum(); j++) {
							Cell ss=row.getCell(j);
							if(ss!=null && !"".equals(ss.toString())){
								switch(j){
								case 0:ss.setCellType(1); name = ss.getStringCellValue(); break;
								case 1:ss.setCellType(1); id = ss.getStringCellValue();  break;
								case 2:ss.setCellType(1); team = ss.getStringCellValue(); break;
								case 3:ss.setCellType(1); post = ss.getStringCellValue(); break;
								case 4:								
									if(ss.getCellType()==0){
										ss.setCellType(0); startDate = datetemp.format(ss.getDateCellValue());
									}  
									break;
								case 5:
									if(ss.getCellType()==0){
										ss.setCellType(0); endDate = datetemp.format(ss.getDateCellValue());
									}
									break;
								default:break;
								}
							}
						}
						if(name!=null && !"".equals(name) && id!=null && !"".equals(id)){
							contents.append(id).append("@").append(name).append("@");
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
							
							 String sql = "select e.employee_name, e.employee_id_code_no, e.employee_id, h.employee_cd , nvl(h.deploy_status,0) deploy_status   from comm_human_employee e  left join comm_human_employee_hr h       on e.employee_id = h.employee_id   and h.bsflag='0' where e.bsflag='0'  and  h.employee_cd ='"+id+"' ";
							 System.out.println("sql ="+sql);	
							 String deploy_status="";
								List list = BeanFactory.getQueryJdbcDAO().queryRecords(sql); 
								if(list.size()>0){  
									Map map = (Map)list.get(0); 
									deploy_status = (String)map.get("deployStatus");
								 
									 if(deploy_status.equals("1")){
										 errors+="第"+(i+1)+"行人员调配中,不可重复调配;\\n";
									 
									 }
									 if(deploy_status.equals("2")){
										 errors+="第"+(i+1)+"行人员已调配,不可重复调配;\\n";
									 }
								 
								}else {
									 errors+="第"+(i+1)+"行人员编号不存在,请正确输入;\\n";
								}
								
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

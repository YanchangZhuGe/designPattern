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
	
	String content = "" ; 
	
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
					for (int i = 1; i <= sheet.getLastRowNum(); i++) {
						row = sheet.getRow(i); 
						
						String dev_type = "";
						String self_num = "";
						String asset_coding = "";
						String erp_id = "";
						String dev_sign = "";
			  
						for (int j = row.getFirstCellNum(); j < row.getLastCellNum(); j++) {
							Cell ss=row.getCell(j);
							if(ss!=null && !"".equals(ss.toString())){
								switch(j){
								case 0:ss.setCellType(1); dev_type = ss.getStringCellValue(); break;
								case 1:ss.setCellType(1); self_num = ss.getStringCellValue();  break;
								case 2:ss.setCellType(1); asset_coding = ss.getStringCellValue(); break;
								case 3:ss.setCellType(1); erp_id = ss.getStringCellValue(); break;
								case 4:ss.setCellType(1); dev_sign = ss.getStringCellValue(); break;
								default:break;
								}
							}
						}
						
						//Æ´²éÑ¯Ìõ¼þ
						if(!content.equals("")){
							content = content + " or ";	
						}
						content += "(";
						
						if(dev_type!=null&&!dev_type.equals("")){
							content += " t.dev_type='"+dev_type+"'" ;
						}
						if((dev_type!=null&&!dev_type.equals(""))&&((self_num!=null&&!self_num.equals(""))||(asset_coding!=null&&!asset_coding.equals(""))||(erp_id!=null&&!erp_id.equals(""))||(dev_sign!=null&&!dev_sign.equals("")))){
							content += " and ";
						}
						if(self_num!=null&&!self_num.equals("")){
							content += " t.self_num='"+self_num+"'" ;
						}
						if((self_num!=null&&!self_num.equals(""))&&((asset_coding!=null&&!asset_coding.equals(""))||(erp_id!=null&&!erp_id.equals(""))||(dev_sign!=null&&!dev_sign.equals("")))){
							content += " and ";
						}
						if(asset_coding!=null&&!asset_coding.equals("")){
							content += " t.asset_coding='"+asset_coding+"'";
						}
						if((asset_coding!=null&&!asset_coding.equals(""))&&((erp_id!=null&&!erp_id.equals(""))||(dev_sign!=null&&!dev_sign.equals("")))){
							content += " and ";
						}
						if(erp_id!=null&&!erp_id.equals("")){
							content += " substr(t.foreign_key,8)='"+erp_id+"'";
						}
						if((erp_id!=null&&!erp_id.equals(""))&&((dev_sign!=null&&!dev_sign.equals("")))){
							content += " and ";
						}
						if(dev_sign!=null&&!dev_sign.equals("")){
							content += " t.dev_sign='"+dev_sign+"'";
						}
						
						if((dev_type!=null&&!dev_type.equals(""))||(self_num!=null&&!self_num.equals(""))||(asset_coding!=null&&!asset_coding.equals(""))||(erp_id!=null&&!erp_id.equals(""))||(dev_sign!=null&&!dev_sign.equals(""))){
							content = content+") ";
						}
					}
					
					if(!content.equals("")){
						content = " and (" + content + ")";
					}
					
					System.out.println("******************"+content);
				}				
			}catch(Exception e){
				System.out.println(e.getMessage());
				
			}
			returnValue=contents.toString(); 
			if(errors != ""){
				out.write("<script type=\"text/javascript\">parent.alertError('"+ errors+"');parent.content='"+ content + "';window.returnValue='" + content+ "';</script>");
			}else{
				out.write("<script type=\"text/javascript\">parent.content=\"" + content + "\";window.returnValue=\"" + content+ "\";</script>");
			}
			
		}
	}
	
%>


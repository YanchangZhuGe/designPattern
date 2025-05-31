<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	String contextPath = request.getContextPath();
	String doc_ucm_ID = request.getParameter("docId");
	String is_doc_version = request.getParameter("docVersion") != null?request.getParameter("docVersion"):"";
	String is_deleted_file = request.getParameter("is_deleted") != null?request.getParameter("is_deleted"):"";
	System.out.println("is doc version :"+is_doc_version);
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>下载文档</title>
</head>
<body>
<script type="text/javascript">
	var is_doc_version = "<%=is_doc_version%>";
	var is_deleted_file = "<%=is_deleted_file%>";
	if(is_doc_version == "docversion"){
		//版本查看文档,通过ucmid
		
		if(is_deleted_file != ""&&is_deleted_file!=null){
			window.location.href="<%=contextPath%>/doc/downloadDeletedDocByUcmId.srq?docId=<%=doc_ucm_ID%>";
		}else{
			window.location.href="<%=contextPath%>/doc/downloadDocByUcmId.srq?docId=<%=doc_ucm_ID%>";
		}
	}else{
		if(is_deleted_file != ""&&is_deleted_file!=null){
			window.location.href="<%=contextPath%>/doc/downloadDelDoc.srq?docId=<%=doc_ucm_ID%>";
		}else{
			window.location.href="<%=contextPath%>/doc/downloadDoc.srq?docId=<%=doc_ucm_ID%>";
		}
	}
	
</script>
</body>
</html>
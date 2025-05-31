<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.zhuozhengsoft.ZSOfficeX.*, java.awt.*"%>
<jsp:useBean id="ZSOfficeCtrl" scope="page" class="com.zhuozhengsoft.ZSOfficeX.ZSOfficeCtrl"></jsp:useBean>  
<%
	String contextPath = request.getContextPath();
	String doc_ucm_ID = request.getParameter("ucmId");
	String is_deleted_file = request.getParameter("isdeleted");
	String word_path = "";
	String view_txt_path = "";
	String is_doc_version = request.getParameter("docVersion")!=null ? request.getParameter("docVersion"):"";
	if(is_doc_version != ""){
		//文档版本中查看文档,根据ucmid
		word_path = contextPath+"/doc/downloadDocByUcmId.srq?docId="+request.getParameter("ucmId")+"&action=view&isdeleted="+is_deleted_file;
		view_txt_path = contextPath+"/doc/viewTxtFileByUcmId.srq?docId="+request.getParameter("ucmId")+"&action=view&isdeleted="+is_deleted_file;
		if(is_deleted_file != ""&& is_deleted_file != null){
			word_path = contextPath+"/doc//doc/downloadDeletedDocByUcmId.srq?docId="+request.getParameter("ucmId")+"&action=view&isdeleted="+is_deleted_file;
		}
	}else{
		word_path = contextPath+"/doc/downloadDoc.srq?docId="+request.getParameter("ucmId")+"&action=view&isdeleted="+is_deleted_file;
		view_txt_path = contextPath+"/doc/viewTxtFileByFileId.srq?docId="+request.getParameter("ucmId")+"&action=view&isdeleted="+is_deleted_file;
		if(is_deleted_file != ""&& is_deleted_file != null){
			word_path = contextPath+"/doc/downloadDelDoc.srq?docId="+request.getParameter("ucmId")+"&action=view&isdeleted="+is_deleted_file;
		}
	}
	
	String doc_extension = request.getParameter("fileExt");
	ZSOfficeCtrl.ServerURL = contextPath+"/zsserver.do"; 
	ZSOfficeCtrl.Menubar = false;
	ZSOfficeCtrl.Toolbars = false;
	ZSOfficeCtrl.Caption = "在线查看文档"; 
	
	int flag = 0;
	int txtFlag = 0;
	String warningMessage = "";
	if("doc".equals(doc_extension)||"docx".equals(doc_extension)){
		 ZSOfficeCtrl.webOpen(word_path, 3, "somebody", "Word.Document");
	}
	else if("ppt".equals(doc_extension)||"pptx".equals(doc_extension)){
		ZSOfficeCtrl.webOpen(word_path, 1, "somebody", "PowerPoint.Show");
	}
	else if("xls".equals(doc_extension)||"xlsx".equals(doc_extension)){
		ZSOfficeCtrl.webOpen(word_path, 1, "somebody", "Excel.Sheet");
	}
	else if("txt".equals(doc_extension)||"TXT".equals(doc_extension)){
		response.sendRedirect(view_txt_path);
	}
	else{
		flag = 1;
		warningMessage = "不支持打开当前格式文件";
	}	
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
 
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>在线查看文档</title>
<style type="text/css">
html,body { height:100%; margin:0; overflow-y:hidden;}
</style>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link href="images/csstg.css" type="text/css" rel="stylesheet"/>
<link rel="stylesheet" type="text/css" href="<%=contextPath %>/css/cn/style.css"/>
<link rel="stylesheet" type="text/css" href="<%=contextPath %>/css/cn/jquery_ui/jquery.ui.all.css"/>
<link rel="stylesheet" href="<%=contextPath%>/js/extjs/resources/css/ext-all.css"/>
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/external/jquery.bgiframe-2.1.2.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/ui/jquery.ui.core.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/ui/jquery.ui.widget.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/ui/jquery.ui.mouse.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/ui/jquery.ui.draggable.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/ui/jquery.ui.position.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/ui/jquery.ui.resizable.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/ui/jquery.ui.dialog.js"></script>
</head>
<body>
 
<div id="content">
 
<div id="textcontent"> 
    
    <!--**************   ZSOFFICE 客户端代码开始    ************************-->
	<SCRIPT language="JavaScript" event="OnInit()" for="ZSOfficeCtrl">
		// 控件打开文档前触发，用来初始化界面样式
	</SCRIPT>
	<SCRIPT language="JavaScript" event="OnDocumentOpened(str, obj)" for="ZSOfficeCtrl">
		// 控件打开文档后立即触发，添加自定义菜单，自定义工具栏，禁止打印，禁止另存，禁止保存等等
		
	</SCRIPT>
	<SCRIPT language="JavaScript" event="OnDocumentClosed()" for="ZSOfficeCtrl">
		
	</SCRIPT>
	<SCRIPT language="JavaScript" event="OnUserMenuClick(index, caption)" for="ZSOfficeCtrl">
		// 添加您的自定义菜单项事件响应
		
	</SCRIPT>
	<SCRIPT language="JavaScript" event="OnCustomToolBarClick(index, caption)" for="ZSOfficeCtrl">
		// 添加您的自定义工具栏按钮事件响应
	</SCRIPT>	
	<%=ZSOfficeCtrl.getDocumentView("ZSOfficeCtrl", request)%> 
	<!--**************   ZSOFFICE 客户端代码结束    ************************-->
	</div>
	</div>
	
	<script type="text/javascript">
		$(function(){
			$(window).resize(doResize);

			doResize();
		});
		
		function doResize(){
			var h = $(window).height();
			$('#textcontent').css('height',h-1);
		}
	</script>
	<script type="text/javascript">
		if(1 == <%=flag%>){
			alert("<%=warningMessage%>");
			window.location.href="<%=contextPath%>/doc/onlineview/download_file.jsp?docId=<%=doc_ucm_ID%>&docVersion=<%=is_doc_version%>&is_deleted=<%=is_deleted_file%>";			
		}
	</script>
	</body>
	</html>


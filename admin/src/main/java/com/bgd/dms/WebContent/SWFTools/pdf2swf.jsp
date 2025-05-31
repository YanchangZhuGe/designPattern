<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.net.URLDecoder"%>
<%
   String contextPath = request.getContextPath();

 String swfFilePath = request.getParameter("fileSwf");
 swfFilePath = java.net.URLDecoder.decode(swfFilePath,"UTF-8"); 
 swfFilePath = swfFilePath.substring(swfFilePath.indexOf("SWFTools")+9,swfFilePath.length());
 System.out.println("swfFilePath======"+swfFilePath);
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script type="text/javascript" src="<%=contextPath %>/FlexPaper/js/flexpaper_flash.js"></script>
<script type="text/javascript" src="<%=contextPath%>/FlexPaper/js/jquery.js"></script> 
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script> 
<style type="text/css" media="screen">
html,body {
	height: 100%;
}

body {
	margin: 0;
	padding: 0;
	overflow: auto;
}

#flashContent {
	display: none;
}
</style>

<title>文档在线预览系统</title>
</head>

<body  >
	  <div style="position:absolute;left:250px;top:10px;">  
            <a id="viewerPlaceHolder" style="width:820px;height:650px;display:block"></a>  
              
            <script type="text/javascript">
        
                var fp = new FlexPaperViewer(     
                         '<%=contextPath %>/FlexPaper/FlexPaperViewer',  
                         'viewerPlaceHolder', { 
                         config : {  
                         SwfFile : escape('<%=swfFilePath %>'),  
                         Scale : 0.6,   
                         ZoomTransition : 'easeOut',  
                         ZoomTime : 0.5,  
                         ZoomInterval : 0.2,  
                         FitPageOnLoad : true,  
                         FitWidthOnLoad : false,  
                         FullScreenAsMaxWindow : false,  
                         ProgressiveLoading : false,  
                         MinZoomSize : 0.2,  
                         MaxZoomSize : 5,  
                         SearchMatchAll : false,  
                         InitViewMode : 'Portrait',  
                           
                         ViewModeToolsVisible : true,  
                         ZoomToolsVisible : true,  
                         NavToolsVisible : true,  
                         CursorToolsVisible : true,  
                         SearchToolsVisible : true,  
                          
                         localeChain: 'zh_CN'  
                         }});  
	        </script>
	</div>
</body>
</html>

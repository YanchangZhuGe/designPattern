<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="auth" uri="auth"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil,com.bgp.gms.service.td.srv.TdDocServiceSrv"%>
<%
String contextPath = request.getContextPath();
String parent_file_id = request.getParameter("parent_file_id")==null?"":request.getParameter("parent_file_id");
String fileId = request.getParameter("id");
String fileAbbr = request.getParameter("fileAbbr");
TdDocServiceSrv serviceSrv = new TdDocServiceSrv();
String docFields = serviceSrv.processDocValuesInfo(fileAbbr, fileId,contextPath);
%> 
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>修改文档</title>
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels2.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/verify.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" />
<!-- 上传控件相关的js css-->
<!-- 文件上传引用的包 -->
<link href="<%=contextPath%>/css/stream-v1.css" rel="stylesheet" type="text/css">
<script type="text/javascript" src="<%=contextPath%>/js/stream-v1.js"></script>

</head>
<body>
<form name="form1" id="form1" method="post" action="<%=contextPath%>/td/toEditTdConsDoc.srq">
<div id="new_table_box">
  <div id="new_table_box_content">
    <div id="new_table_box_bg">
	<table  border="0" cellpadding="0" cellspacing="0" class="tab_line_height" width="100%">
  	<tr>
    	<td colspan="4" align="center">修改文档
    	<input type="hidden" name="file_id" id="file_id" value=""/>
    	<input type="hidden" name="upload_file_name" id="upload_file_name"/>
        <input name="doc_type_s" id="doc_type_s" class="input_width"  type="hidden" />  
        <input name="file_abbr" id="file_abbr" class="input_width"  type="hidden"  />
        <input name="parent_file_id" id="parent_file_id" class="input_width" value="<%=parent_file_id%>" type="hidden" readonly="readonly"/>
    	</td>
    	
    </tr>
    <%=docFields %>
    <tr>

     	<td class="inquire_item4">文档类型：</td>
      	<td class="inquire_form4">
      		<select name="doc_type" id="doc_type" class="select_width">
	      		<option value="0">-请选择-</option>
	      		<option value="word">word</option>
	      		<option value="excel">excel</option>
	      		<option value="ppt">PowerPoint</option>
	      		<option value="pdf">PDF</option>
	      		<option value="txt">TXT</option>
	      		<option value="picture">图片文件</option>
	      		<option value="compress">压缩文件</option>
	      		<option value="other">其他文件</option>
	      	</select>
      	</td>
    	<td class="inquire_item4"> </td>
      	<td class="inquire_form4"> </td>
    </tr>
    <tr>
    	<td class="inquire_item4">文档标题：</td>
      	<td class="inquire_form4"><input type="text" name="doc_name" id="doc_name" class="input_width" /></td>
		<td class="inquire_item4">重要程度：</td>
      	<td class="inquire_form4">
	      	<select name="doc_importance" id="doc_importance" class="select_width">
	      		<option value=" ">-请选择-</option>
	      		<option value="1">高</option>
	      		<option value="2">中</option>
	      		<option value="3">低</option>
	      	</select>
      	</td>
    </tr>    
   <tr>
      	<td class="inquire_item4">关键字</td>
      	<td class="inquire_form4">
      		<input type="text" name="doc_keyword" id="doc_keyword" class="input_width"/>
      	</td>
      	<td class="inquire_item4">是否模板：</td>
      	<td class="inquire_form4">
      	    <select name="doc_template" id="doc_template" class="select_width">
	      		<option value=" ">-请选择-</option>
	      		<option value="1">是</option>
	      		<option value="0">否</option>
	      	</select>
      	</td>
    </tr> 
    <tr>
		<td class="inquire_item4">摘要：</td>
      	<td class="inquire_form4"><input type="text" name="doc_brief" id="doc_brief" class="input_width"/></td>
      	<td class="inquire_item4">分数</td>
      	<td class="inquire_form4">
      		<select name="doc_score" id="doc_score" class="select_width">
	      		<option value=" ">-请选择-</option>
	      		<option value="10">10</option>
	      		<option value="20">20</option>
	      		<option value="30">30</option>
	      		<option value="40">40</option>
	      		<option value="50">50</option>
	      		<option value="60">60</option>
	      		<option value="70">70</option>
	      		<option value="80">80</option>
	      		<option value="90">90</option>
	      		<option value="100">100</option>
	      	</select>
      	</td>
    </tr>
    <tr>
      	<td class="inquire_item4">文档名称：</td>
      	<td class="inquire_form4" id="the_file_name">&nbsp;</td>
      	<td class="inquire_item4">&nbsp;</td>
      	<td class="inquire_form4">&nbsp;</td>
    </tr>    
    <tr>
    	<td class="inquire_item4">文档：</td>
    	<td colspan = "3"> 
    		<div id="i_select_files">
	       </div>

	      <div id="i_stream_files_queue">
	    </div> 
       	 	<!-- <div style="float:left" id="fileQueue" style="border:1px solid green;width:400px"></div>
			<div id="file_content" style="float:left"> <input type="file"  name="file" id="file"/>	 </div>
			<div id="status-message"></div>  -->
		</td>
    </tr>
    
<!--     
	<tr>
    	<td colspan="4" class="ali3">
    	    <input name="Submit2" type="button" onClick="save()" value="上传" />
    		<input name="Submit2" type="button" onClick="cancel()" value="返回" />&nbsp;
    	<td>
    </tr>  
-->   

</table>
</div>
    <div id="oper_div">
        <auth:ListButton functionId="" css="tj_btn" event="onclick='refreshData()'"></auth:ListButton>
        <auth:ListButton functionId="" css="gb_btn" event="onclick='newClose()'"></auth:ListButton>
    </div>
</div>
</div> 
</form>
</body>

<script type="text/javascript">
	cruConfig.contextPath =  "<%=contextPath%>";
	
	var file_id = '<%=request.getParameter("id")%>';
 
	
	getEditDocInfo();
	
	function getEditDocInfo(){
		
		var retObj = jcdpCallService("TdDocServiceSrv", "getEditDocInfo", "fileId="+file_id);		
		document.getElementById("file_id").value= retObj.docInfoMap.file_id != undefined ? retObj.docInfoMap.file_id:"";	
		document.getElementById("doc_importance").value= retObj.docInfoMap.doc_importance != undefined ? retObj.docInfoMap.doc_importance:"";
		document.getElementById("doc_keyword").value= retObj.docInfoMap.doc_keyword != undefined ? retObj.docInfoMap.doc_keyword:"";
		document.getElementById("doc_score").value= retObj.docInfoMap.doc_score != undefined ? retObj.docInfoMap.doc_score:"";
		document.getElementById("doc_template").value= retObj.docInfoMap.doc_template != undefined ? retObj.docInfoMap.doc_template:"";
		document.getElementById("doc_brief").value= retObj.docInfoMap.doc_keyword != undefined ? retObj.docInfoMap.doc_brief:"";
 
		document.getElementById("doc_type").value= retObj.docInfoMap.doc_type != undefined ? retObj.docInfoMap.doc_type:"";	
		document.getElementById("doc_name").value= retObj.docInfoMap.doc_name != undefined ? retObj.docInfoMap.doc_name:"";	
		document.getElementById("doc_type_s").value= retObj.docInfoMap.doc_type_s != undefined ? retObj.docInfoMap.doc_type_s:"";	
		document.getElementById("file_abbr").value= retObj.docInfoMap.file_abbr != undefined ? retObj.docInfoMap.file_abbr:"";	
		if(retObj.docInfoMap.file_id == undefined){
			document.getElementById("the_file_name").innerHTML = "未上传文档";
		}else{
			document.getElementById("the_file_name").innerHTML = "<a href='<%=contextPath%>/doc/downloadDoc.srq?docId="+retObj.docInfoMap.file_id+"'>"+retObj.docInfoMap.orig_doc_name+"</a>";

		}
	}		
	
	function refreshData(){
		document.getElementById("form1").submit();
	}

	 
	/**
	 * 配置文件（如果没有默认字样，说明默认值就是注释下的值）
	 * 但是，on*（onSelect， onMaxSizeExceed...）等函数的默认行为
	 * 是在ID为i_stream_message_container的页面元素中写日志
	 */
	 var config = {
		        multipleFiles: false, /** 多个文件一起上传, 默认: false */
		        swfURL : "<%=contextPath%>/swf/FlashUploader.swf", /** SWF文件的位置 */
		        tokenURL : "<%=contextPath%>/tk", /** 根据文件名、大小等信息获取Token的URI（用于生成断点续传、跨域的令牌） */
		        frmUploadURL : "<%=contextPath%>/fd;", /** Flash上传的URI */
		        uploadURL : "<%=contextPath%>/upload", /** HTML5上传的URI */
		        browseFileBtn : "<div id='selectFile' style='color:red' >选择上传文件</div>",
		        simLimit : 1,
		        onComplete :  function(file) {
		            document.getElementById("upload_file_name").value = file.name;
		        document.getElementById("doc_name").value = file.name;
		            alert("文件：  已上传成功！");
		        	  },
		        onUploadError: function(status, msg) {
		        	      alert("上传文件出错，代码：" + status
		        	       + "|错误：" + msg);
		         }
		    };
		    var _t = new Stream(config);
	
</script>
</html>
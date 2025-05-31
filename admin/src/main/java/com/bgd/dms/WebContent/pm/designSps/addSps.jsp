<%@page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%
    String contextPath = request.getContextPath();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>新增设计SPS文件</title>
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels2.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/verify.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<!-- 文件上传引用的包  start-->
<link href="<%=contextPath%>/css/stream-v1.css" rel="stylesheet" type="text/css">
<script type="text/javascript" src="<%=contextPath%>/js/stream-v1.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" />
<!-- 文件上传引用的包  end-->


 
</head>
<body>
<form id="CheckForm" name="form1" enctype="multipart/form-data" action="" method="post" >
<input type="hidden" name="upload_file_name" id="upload_file_name" /> 
<div id="new_table_box">
  <div id="new_table_box_content">
    <div id="new_table_box_bg">
	<table  border="0" cellpadding="0" cellspacing="0" class="tab_line_height">
  	<tr>
   		<td class="inquire_item4"><font color="red">*</font>&nbsp;测线号：</td>
   		<td class="inquire_form4" colspan="3"><input id="line_group_id" name="line_group_id" type="text" value="" class="input_width" /></td>
  	</tr>
    <tr>
 <tr>
    	<td class="inquire_item4"><font color="red">*</font>文档：</td>
    	<td colspan = "3"> 
       	 	<!--  在线文档上传 start--> 
    		<div id="i_select_files">
	       </div>

	      <div id="i_stream_files_queue">
	    </div> 
	    <!--  在线文档上传  end-->
		</td>
    </tr>
  	  <tr> 
    	<td colspan = "4"> 
       	 <font color="red">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;至少需要上传三个文件：X、R、S,否则不让提交;其他文件可传可不传</font>
		</td>
    </tr>
	</table>
  </div>
  <div id="oper_div">
   	<span class="tj_btn"><a href="#" onclick="toSave()"></a></span>
    <span class="gb_btn"><a href="#" onclick="newClose()"></a></span>
  </div>
</div></div>
</form>
</body>
<script type="text/javascript">
cruConfig.contextPath =  "<%=contextPath%>";
cruConfig.cdtType = 'form';
var uploadFileNames= ""; 
function toSave(){
	var flag = validateValue();

	if(flag){
		return false;
	} else {
	    document.getElementById("upload_file_name").value = uploadFileNames;
		//tijiao
		var form = document.forms[0];
		alert(uploadFileNames);
		form.action="<%=contextPath%>/pm/gpe/saveDesignSps.srq";
		form.submit();
	}
}

function validateValue(){
    var lineId = document.getElementById("line_group_id").value;
    
    if(lineId == ""){ 
	    alert("测线号不能为空！");
	    return false; 
    }
   if(uploadFileNames.indexOf("X") ==-1) {
        alert("缺少X文件，请确定！");
	    return false; 
   } 
   if(uploadFileNames.indexOf("S") ==-1) {
       alert("缺少S文件，请确定！");
	    return false; 
   } 
   if(uploadFileNames.indexOf("R") ==-1) {
       alert("缺少R文件，请确定！");
	    return false; 
   } 
   var files = uploadFileNames.split("$GMS$");
   
   if(files.length > 3){
       alert("应该至少上传三个文件，目前上传"+files.length);
       return false; 
   } 
}
/**
 * 配置文件（如果没有默认字样，说明默认值就是注释下的值）
 * 但是，on*（onSelect， onMaxSizeExceed...）等函数的默认行为
 * 是在ID为i_stream_message_container的页面元素中写日志
 * 在线文档上传
 */

 var config = {
	        multipleFiles: true, /** 多个文件一起上传, 默认: false */
	        swfURL : "<%=contextPath%>/swf/FlashUploader.swf", /** SWF文件的位置 */
	        tokenURL : "<%=contextPath%>/tk", /** 根据文件名、大小等信息获取Token的URI（用于生成断点续传、跨域的令牌） */
	        frmUploadURL : "<%=contextPath%>/fd;", /** Flash上传的URI */
	        uploadURL : "<%=contextPath%>/upload", /** HTML5上传的URI */
	        browseFileBtn : "<div id='selectFile' style='color:red' >选择上传文件</div>",
	        simLimit : 4,
	        onComplete :  function(file) { 
	            if(uploadFileNames == ""){
	        	   uploadFileNames=file.name; 
	            } else {
	        	  uploadFileNames = uploadFileNames + "#GMS#" +file.name;
	            }
	        },
	        onQueueComplete: function(msg){
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
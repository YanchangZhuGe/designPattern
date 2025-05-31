
<%@ page contentType="text/html;charset=utf-8" language="java" pageEncoding="utf-8"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@taglib prefix="auth" uri="auth"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>


<%
	String contextPath = request.getContextPath();
   
    UserToken user = OMSMVCUtil.getUserToken(request);
    String userId = (user==null)?"":user.getEmpId();
    String projectInfoNo = user.getProjectInfoNo();
    SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
    String curDate = format.format(new Date());
    
%> 
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>上传文档</title>
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels2.css" rel="stylesheet" type="text/css" />
<!-- 文件上传引用的包  start-->
<link href="<%=contextPath%>/css/stream-v1.css" rel="stylesheet" type="text/css">
<script type="text/javascript" src="<%=contextPath%>/js/stream-v1.js"></script>
<!-- 文件上传引用的包  end-->

<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/verify.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>

</head>
<body>
<form name="form1" id="form1" method="post" action="<%=contextPath%>/pm/dailyPlan/importDailyUploadFile.srq">
<div id="new_table_box">
  <div id="new_table_box_content">
    <div id="new_table_box_bg">
	<table  border="0" cellpadding="0" cellspacing="0" class="tab_line_height" width="100%">
	
  	<tr>
    	<td colspan="4" align="center">上传文档
    	<input type="hidden" name="upload_file_name" id="upload_file_name" /> 
    	</td>
    </tr>

   
    <tr>
    	<td class="inquire_item4"><font color="red">*</font>文档：</td>
    	<td colspan = "3">
    	<div id="i_select_files"></div>

	      <div id="i_stream_files_queue">
	    </div> 

		</td>
    </tr>   
    </table>
    
	<div id="showinfo" style="display:none;">
    
</div>
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
	var nowDate = new Date();
 
	var fileAbbr = "";
    
	function cancel()
	{
		window.close();
	}
										
	function save(){	
		if (!checkForm()) return;
		
		document.getElementById("form1").submit();
	}	
	
	function checkForm(){ 	

		if (!isTextPropertyNotNull("upload_file_name", "文档内容")) {		
 
			return false;	
		}
 
		return true;
	}
	
	function refreshData(){
		if(checkUploadFileSuc()){
			document.getElementById("form1").submit();
		}
	}
	function  checkUploadFileSuc(){
	    var fileName = document.getElementById("upload_file_name").value;
	    if(fileName == null || fileName==""){
		    alert("请选择文件后在提交！");
		    return false;
	    }
	    return true;
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
		        simLimit : 100,
		        onComplete :  function(file) {
		            document.getElementById("upload_file_name").value += file.name+",";
		          //  alert("文件：  已上传成功！");
		        	  },
		        onUploadError: function(status, msg) {
		        	      alert("上传文件出错，代码：" + status
		        	       + "|错误：" + msg);
		         }
		    };
		    var _t = new Stream(config);
	
</script>
</html>
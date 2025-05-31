<%@ page contentType="text/html;charset=GBK" pageEncoding="GBK"%>
<!DOCTYPE html>
<html>
<head>
<title>文件上传</title>	
<meta http-equiv="Content-Type" content="text/html; charset=GBK">
<link href="/gms4/css/stream-v1.css" rel="stylesheet" type="text/css">
</head>
<body>
	<div id="i_select_files"  >
	</div>

	<div id="i_stream_files_queue" >
	</div> 
	<!-- 
	<button onclick="javascript:_t.upload();">开始上传</button>|<button onclick="javascript:_t.stop();">停止上传</button>|<button onclick="javascript:_t.cancel();">取消</button>
	|<button onclick="javascript:_t.disable();">禁用文件选择</button>|<button onclick="javascript:_t.enable();">启用文件选择</button>
	<br>
	 
	Messages:
	<div id="i_stream_message_container" class="stream-main-upload-box" style="overflow: auto;height:200px;">
	</div>
	-->
<br>

<link href="/gms4/css/stream-v1.css" rel="stylesheet" type="text/css">
<script type="text/javascript" src="/gms4/js/stream-v1.js"></script>
<script type="text/javascript">
/**
 * 配置文件（如果没有默认字样，说明默认值就是注释下的值）
 * 但是，on*（onSelect， onMaxSizeExceed...）等函数的默认行为
 * 是在ID为i_stream_message_container的页面元素中写日志
 */
 var config = {
	        multipleFiles: false, /** 多个文件一起上传, 默认: false */
	        swfURL : "/gms4/swf/FlashUploader.swf", /** SWF文件的位置 */
	        tokenURL : "/gms4/tk", /** 根据文件名、大小等信息获取Token的URI（用于生成断点续传、跨域的令牌） */
	        frmUploadURL : "/mgs4/fd;", /** Flash上传的URI */
	        uploadURL : "/gms4/upload", /** HTML5上传的URI */
	        browseFileBtn : "<div id='selectFile' style='color:red' >选择上传文件</div>",/**选择上传文件按钮*/
	        simLimit : 1 ,/**上传文件个数*/
	        onComplete :  function(file) {
	            alert("文件： " + file.name 
	        	    + "|" + file.size + " 已上传成功！");
	        	  },
	        onUploadError: function(status, msg) {
	        	      alert("上传文件出错，代码：" + status
	        	       + "|错误：" + msg);
	         }
	        	    	        	  
	        	  	        
	    };
	    var _t = new Stream(config);

</script>
</body>
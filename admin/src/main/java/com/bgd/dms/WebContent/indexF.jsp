<%@ page contentType="text/html;charset=GBK" pageEncoding="GBK"%>
<!DOCTYPE html>
<html>
<head>
<title>�ļ��ϴ�</title>	
<meta http-equiv="Content-Type" content="text/html; charset=GBK">
<link href="/gms4/css/stream-v1.css" rel="stylesheet" type="text/css">
</head>
<body>
	<div id="i_select_files"  >
	</div>

	<div id="i_stream_files_queue" >
	</div> 
	<!-- 
	<button onclick="javascript:_t.upload();">��ʼ�ϴ�</button>|<button onclick="javascript:_t.stop();">ֹͣ�ϴ�</button>|<button onclick="javascript:_t.cancel();">ȡ��</button>
	|<button onclick="javascript:_t.disable();">�����ļ�ѡ��</button>|<button onclick="javascript:_t.enable();">�����ļ�ѡ��</button>
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
 * �����ļ������û��Ĭ��������˵��Ĭ��ֵ����ע���µ�ֵ��
 * ���ǣ�on*��onSelect�� onMaxSizeExceed...���Ⱥ�����Ĭ����Ϊ
 * ����IDΪi_stream_message_container��ҳ��Ԫ����д��־
 */
 var config = {
	        multipleFiles: false, /** ����ļ�һ���ϴ�, Ĭ��: false */
	        swfURL : "/gms4/swf/FlashUploader.swf", /** SWF�ļ���λ�� */
	        tokenURL : "/gms4/tk", /** �����ļ�������С����Ϣ��ȡToken��URI���������ɶϵ���������������ƣ� */
	        frmUploadURL : "/mgs4/fd;", /** Flash�ϴ���URI */
	        uploadURL : "/gms4/upload", /** HTML5�ϴ���URI */
	        browseFileBtn : "<div id='selectFile' style='color:red' >ѡ���ϴ��ļ�</div>",/**ѡ���ϴ��ļ���ť*/
	        simLimit : 1 ,/**�ϴ��ļ�����*/
	        onComplete :  function(file) {
	            alert("�ļ��� " + file.name 
	        	    + "|" + file.size + " ���ϴ��ɹ���");
	        	  },
	        onUploadError: function(status, msg) {
	        	      alert("�ϴ��ļ��������룺" + status
	        	       + "|����" + msg);
	         }
	        	    	        	  
	        	  	        
	    };
	    var _t = new Stream(config);

</script>
</body>
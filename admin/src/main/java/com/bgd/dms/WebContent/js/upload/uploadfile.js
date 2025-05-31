$(function() {
	var num = 0;//ѡ����ļ�����
	var root = "/DMS";
	$('#file').uploadify({
		'uploader' : root+'/js/upload/uploadify.swf',//uploadify.swf �ļ������·������swf�ļ���һ����������BROWSE�İ�ť������󵭳����ļ��Ի���Ĭ��ֵ��uploadify.swf
		'script' : root+'/servlet/Upload',//��̨�����������·�� ��Ĭ��ֵ��uploadify.php 
		'cancelImg' : root+'/js/upload/cancel.png',//
		//'checkScript' 	��false,//�����ж��ϴ�ѡ����ļ��ڷ������Ƿ���ڵĺ�̨�����������·�� 
		'fileDataName' : 'file',//����һ�����֣��ڷ�������������и��ݸ�������ȡ�ϴ��ļ������ݡ�Ĭ��ΪFiledata 
		'folder' : root+'/upload',//�ϴ��ļ���ŵ�Ŀ¼
		'fileExt' : '*.jpg;*.gif;*.png',//���ÿ���ѡ����ļ������ͣ���ʽ�磺'*.doc;*.pdf;*.rar' 
		'fileDesc' : '',//�������ֵ��������fileExt���Ժ����Ч����������ѡ���ļ��Ի����е���ʾ�ı���Web Image Files (.JPG, .GIF, .PNG)������fileDescΪ����ѡ��rar doc pdf�ļ���
		'queueID' : 'fileQueue',//�ļ����е�ID����ID�����ļ����е�div��IDһ��
		'removeCompleted' : false,//�ϴ���ɺ��Ƿ����ѡ����ļ�
		'height' : 22,//�����ť�ĸߵ�
		'width' : 66,//�����ť�Ŀ��
		'buttonImg' : root+'/images/liulanh.png',//�����ť��ͼƬ��ַ
		// 'buttonText' 		: 'Upload Image',//��ť���ı�
		'multi' : false,//�Ƿ�������ļ��ϴ�
		'auto' : true,//��ѡ���ļ�֮���Ƿ������ύ
		/**
		ѡ��������ϴ��ڼ�ʲô�������齫����ʾ���ļ��ϴ������С�Ĭ������£�����ʾ�ϴ����ȵİٷֱȡ�����Խ���ѡ���ֵ����Ϊ"speed"����ʾ�ϴ��ٶȣ���λΪKB/s Ĭ��ֵ��'percentage' ȡֵ��ʽ:'percentage' / 'speed'
		 */
		'displayData' : 'speed',
		'queueSizeLimit' : 1,//��������ļ�����ʱ������ѡ���ļ��ĸ�����Ĭ��ֵ��999 
		'simUploadLimit' : 1,//����ͬʱ�ϴ��ĸ��� Ĭ��ֵ��1
		'sizeLimit' : 500 * 1024 * 1024,//����ϴ��ļ���С��100MB 
		/**
		    �ڵ��ļ�����ļ��ϴ�ʱ��ѡ���ļ�ʱ�������ú�������������event��data��data���������¼������ԣ�
		?fileCount��ѡ���ļ��������� 
		?filesSelected��ͬʱѡ���ļ��ĸ��������һ��ѡ����3���ļ�������ֵΪ3�� 
		?filesReplaced������ļ��������Ѿ�����A��B�����ļ����ٴ�ѡ���ļ�ʱ��ѡ����A��B��������ֵΪ2�� 
		?allBytesTotal������ѡ����ļ����ܴ�С�� 
		 */
		'onSelectOnce' : function(event, data) {

			//num += data.filesSelected;
			//$('#status-message').text(num + ' ���ļ���ѡ��.');
		},
		'onAllComplete' : function(event, data) {
			//$('#status-message').text(data.filesUploaded + ' ���ļ��ϴ��ɹ�, ' + data.errors + ' ������.');
			$('#status-message').text('success');
			$("#status-message").show();
			setTimeout(function() {
				//$("#status-message").text("");
				$("#status-message").hide();
			}, 1000);//3���ɾ����ʾ
		},
		'onError' : function(event, queueId, fileObj, errorObj) {

			if (errorObj.type == "HTTP") {
				alert("");
			} else if (errorObj.type == "IO") {
				alert("IO error");
			} else if (errorObj.type == "Security") {
				alert("security error");
			}

		},
		'onSelect' : function(e, queueId, fileObj) {
			//$("#status-message").show();
			var fileName =  fileObj.name;
			getFileInfoNew(fileName);
		}
	});
	$("#up").click(function() {
		num = 0;
	})
	$("#clear").click(function() {
		num = 0;
		$("#status-message").text("");
	})
	
	
	
})
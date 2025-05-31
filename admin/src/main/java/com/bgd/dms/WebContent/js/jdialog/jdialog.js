/**
 * 封装easyui的dialog用于在最顶层弹出dialog
 * (兼容模式下有问题)
 * */
//模态窗口插件
(function($) {
    $.JDialog = {
        option: {
            title:"窗口",
			height:550,
			width:900,
			collapsible: true,
			minimizable: false,
			maximizable: true,
			resizable:true,
			onOpen:function(){
				$.messager.progress({title:'请稍后',msg:'正在打开页面....'}); 
			}
        },
 
        open: function(url,options) {
        	$(".window-shadow").remove();
			$(".window-mask").remove();
			$.messager.progress({title:'请稍后',msg:'页面加载中....'}); 
			  
            var op = $.extend({}, $.JDialog.option, options);
			
            var timestamp = new Date().getTime(); // 加入当前时间戳，建立动态ID避免ID冲突
			var dlgid = "dlg_"+timestamp;
			
			$div = $("<div class='easyui-window' closed='true' modal='true'  style='padding:0px;overflow:hidden;'></div>");
			$div.attr("id", dlgid);
			$("body").append($div);
			
			$dialog =  $("#" + dlgid);
			if (options.param) $dialog.data("param", options.param);
			//保存回调函数
			$dialog.data(dlgid + "callback", options.callback);
			//保存打开dialog的窗口对象
			$dialog.data(dlgid + "win", options.win);
		    $("body").data(dlgid, $dialog);
            iframe = $("<iframe>").attr({ "src":"", "frameborder": "0", "marginwidth": "0", "marginheight": "0","name":"frm_"+timestamp,"id":"frm_"+timestamp })
            .css({  "margin": "0px","padding-right":"15px" });
            $dialog.html(iframe);
            
            //注册dialog的改变大小的事件回调函数
            op.onResize= function(){
            	$.JDialog.changeContent(dlgid);
            }
            //绑定dialog关闭事件
           // op.onClose= function(){
            	//获取顶层页面下的iframe(id='indexFrame')
            //	var indexFrame = top.document.getElementById('indexFrame');
            //	var list = indexFrame.contentWindow.document.getElementById('list');
            //	$(list).contents().find("input[type='text']:first").focus();
           // }           
           
            $dialog.dialog(op);            
			$("#frm_" + timestamp).attr("src",url);
			         
			//在iframe的页面中创建top.dialogVal(window)方法，在iframe中使用top.dialogVal(window)取得传递的参数
            top.dialogVal = function(window) {
				 var $windialog = $("body").data("dlg_"+window.name.split("_")[1]);
                if ($windialog.data("param") != undefined && $windialog.data("param") != null) {
                    return $windialog.data("param");
                } else {
                    return "";
                }
            }
						
            //在iframe的页面中创建top.closeDialog方法，在iframe中使用top.closeDialog(window)关闭窗口
            top.closeDialog = function(window) {				
                $.JDialog.close("dlg_"+window.name.split("_")[1]);
            }
            //在iframe的页面中创建top.newClose方法，在iframe中使用top.newClose(window)关闭窗口
            top.newClose = function(window) {
                $.JDialog.close("dlg_"+window.name.split("_")[1]);
            }
            //根据弹出窗口的window 的name关闭窗口
            top.closeDialogByWinName = function(name) {
                $.JDialog.close("dlg_"+name.split("_")[1]);
            }
          //根据弹出窗口的window 的name关闭窗口并返还及回调函数
            top.closeDialogByWinNameAndReturn = function(name,returnValue) {
            	var did="dlg_"+name.split("_")[1];
                $.JDialog.returnVal(did, returnValue);
            	 $.JDialog.close(did);
            }
            
            //设置dialog的标题，在iframe的页面中创建top.setDialogTitle(window,title)方法
            //在iframe中使用top.setDialogTitle(window,"新增窗口")设置标题
            top.setDialogTitle = function(window,title) {
                $.JDialog.setTitle("dlg_"+window.name.split("_")[1],title);
            }
 
            //在iframe的页面中创建top.closeDialogAndReturn方法，
            //在iframe中使用top.closeDialogAndReturn(window,returnValue)关闭窗口并返回参数,returnValue为返回的参数
            top.closeDialogAndReturn = function(window,returnValue) {
            	var did="dlg_"+window.name.split("_")[1];
                $.JDialog.returnVal(did, returnValue);
            	 $.JDialog.close(did);
            }
 
           //除去原有的关闭事件并绑定自定义关闭动作
            $("#" + dlgid).siblings(".window-header").find(".panel-tool-close").unbind().bind("click", function() {
                $.JDialog.close(dlgid);
            });
            
			$dialog.dialog('open');
		//页面加载完成，重新调整页面内容大小
		 var myiframe = $("#frm_" + timestamp).get(0);
           if (myiframe.attachEvent){
        	   myiframe.attachEvent("onload", function(){
        		   $.messager.progress('close');
        		   $.JDialog.changeContent(dlgid);
	       	    });
	       	} else {
	       		myiframe.onload = function(){
	       		$.messager.progress('close');
	       		 $.JDialog.changeContent(dlgid);
	       	    };
	       	}		
        },
        changeContent:function(dlgid){
        	
        	var w = parseInt($("#"+dlgid).width());
            var h = parseInt($("#"+dlgid).height());
            var dlgframe = $("#" + dlgid + " iframe");
            dlgframe.width(w);
            dlgframe.height(h);
            dlgframe.contents().find("#new_table_box").height(h);
            dlgframe.contents().find("#new_table_box_content").height(h-25);
            dlgframe.contents().find("#new_table_box_bg").height(h-80);
            //防止焦点丢失
            dlgframe.contents().find("input[type='text']:first").focus();
        },
		
        //关闭dialog
        close: function(dlgid) {
        	dialog = $("body").data(dlgid);
            $("iframe", dialog).remove();
            dialog.dialog("close");
            dialog.parent().remove();  //移除新建的窗口
            dialog.remove();
            //防止焦点丢失
            $("input[type='text']:first", window.top.document).focus();
            //var indexFrame = top.document.getElementById('indexFrame');
        	//var list = indexFrame.contentWindow.document.getElementById('list');
        	//$(list).contents().find("input[type='text']:first").focus();
        },
        //设置标题
        setTitle:function(dlgid,title){
        	dialog = $("body").data(dlgid);
             dialog.dialog("setTitle",title);
        },
        //关闭dialog并执行返回函数
        returnVal: function(dlgid, returnValue) {
        	dialog = $("body").data(dlgid);
            if ($(dialog).data(dlgid + "callback") != null) {
            	$(dialog).data(dlgid + "callback").apply( $(dialog).data(dlgid + "win"), [returnValue]);  //执行回调函数并返回value,value可自行定义，在回调函数中自行操作
            }
        }
    };
 
})(jQuery);